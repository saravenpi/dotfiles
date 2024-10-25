#!/usr/bin/env bun
import { readFileSync, readdirSync } from 'fs'
import * as os from 'os';

type HabitDay = {
	file: string,
	day: Date,
	habits: {},
}

type HabitType = {
	name: string,
	mark: string,
}

type HabitStreak = {
	streak: number,
	maxStreak: number,
}

const HOME_DIR = os.homedir();
const NOTES_DIR = `${HOME_DIR}/notes`
const JOURNAL_DIR = `${NOTES_DIR}/journal/`

const FILE_EXTENSION = '.norg'
const DONE_MARK = '(x)'
const IGNORED_FILES = ['template.norg', 'index.norg']

const HABITS: HabitType[] = [
	{ name: 'drink', mark: '💧' },
	{ name: 'stretch', mark: '🤸' },
	{ name: 'meditate', mark: '🧘' },
	{ name: 'eat', mark: '🍚' },
	{ name: 'clean', mark: '🧹' },
	// { name: 'permis', mark: '🛻' },
]

function getFilesRecursive(dirname: string): string[] {
	const files = readdirSync(dirname, { withFileTypes: true })
	let norgFiles: string[] = []

	files.forEach((file: any) => {
		if (file.isDirectory()) {
			getFilesRecursive(`${dirname}/${file.name}`).forEach((norgFile) => { norgFiles.push(norgFile) })
		} else {
			if (!file.name.endsWith(FILE_EXTENSION) || IGNORED_FILES.includes(file.name)) return
			norgFiles.push(`${dirname}/${file.name}`)
		}
	})
	return norgFiles
}

function parseFileDate(fileName: string): Date {
	fileName = fileName.replace(FILE_EXTENSION, '')
	fileName = fileName.replace(JOURNAL_DIR, '')
	return new Date(fileName)
}

function parseFileContent(fileName: string): HabitDay {
	const content = readFileSync(fileName, 'utf8')
	let habitDay: HabitDay = {
		file: fileName,
		day: new Date(),
		habits: {}
	}

	content.split('\n').forEach((line: string) => {
		for (let habit of HABITS) {
			if (line.includes(habit.mark)) {
				habitDay.habits[habit.name] = line.includes(DONE_MARK)
			}
		}
	})
	habitDay.day = parseFileDate(fileName)
	return habitDay
}

function countStreak(habitDays: HabitDay[], habit: string): HabitStreak {
	let habitStreak: HabitStreak = {
		streak: 0,
		maxStreak: 0
	};

	habitDays.forEach((habitDay) => {
		if (habitDay.habits[habit]) {
			habitStreak.streak++
		} else {
			if (habitDay.day.toDateString() != new Date().toDateString()) {
				habitStreak.maxStreak = Math.max(habitStreak.streak, habitStreak.maxStreak)
				habitStreak.streak = 0
			}
		}
	})
	return habitStreak
}

function getHabitDays() {
	let habitDays: HabitDay[] = []
	let norgFiles: string[] = getFilesRecursive(NOTES_DIR)

	norgFiles.forEach((fileName: string) => {
		if (fileName.includes(JOURNAL_DIR)) {
			let habitDay = parseFileContent(fileName)
			habitDays.push(habitDay)
		}
	})
	habitDays.sort((a, b) => a.day.getTime() - b.day.getTime())

	return habitDays
}

function logHabit(habit: HabitType, habitDays: HabitDay[]) {
	let habitStreak = countStreak(habitDays, habit.name)
	let offset = ""
	if (habit.name.length <= 3) {
		offset = "\t"
	}
	console.log(`${habit.mark} ${habit.name}:\t${offset}${habitStreak.streak} (max: ${habitStreak.maxStreak})\t(today: ${habitDays[habitDays.length - 1].habits[habit.name] ? '🎉' : '🕒'})`)
}

function logStreaks(habitDays: HabitDay[]) {
	let today = new Date()
	let lastHabitDay = habitDays[habitDays.length - 1]
	let todayDone: boolean = true
	if (lastHabitDay.day.toDateString() !== today.toDateString()) {
		console.log(`🚨 Tu n'as pas fait ton entrée aujourd'hui!`)
		todayDone = false
	}

	for (let habit of HABITS) {
		logHabit(habit, habitDays)
	}
}

function main() {
	let habitDays: HabitDay[] = getHabitDays()
	logStreaks(habitDays)
}

main()
