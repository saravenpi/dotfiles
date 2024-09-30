#!/usr/bin/env bun
import { readFileSync, readdirSync } from 'fs'
import * as os from 'os';

type HabitDay = {
	file: string,
	day: Date,
	stretch: boolean,
	meditate: boolean,
	drink: boolean,
	eat: boolean,
	clean: boolean,
}

type HabitType = {
	name: string,
	mark: string,
}

type HabitStreak = {
	streak: number,
	maxStreak: number,
}

const MEDITATE_MARK = '🧘'
const STRETCH_MARK = '🤸'
const DRINK_MARK = '💧'
const EAT_MARK = '🍚'
const CLEAN_MARK = '🧹'
const habits: HabitType[] = [
	{ name: 'meditate', mark: MEDITATE_MARK },
	{ name: 'stretch', mark: STRETCH_MARK },
	{ name: 'drink', mark: DRINK_MARK },
	{ name: 'eat', mark: EAT_MARK },
	{ name: 'clean', mark: CLEAN_MARK },
]

const HOME_DIR = os.homedir();
const NOTES_DIR = `${HOME_DIR}/notes`
const JOURNAL_DIR = `${NOTES_DIR}/journal/`

const FILE_EXTENSION = '.norg'
const DONE_MARK = '(x)'
const IGNORED_FILES = ['template.norg', 'index.norg']

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
		stretch: false,
		meditate: false,
		drink: false,
		clean: false,
		eat: false
	}

	content.split('\n').forEach((line: string, index: number) => {
		if (line.includes(MEDITATE_MARK) && line.includes(DONE_MARK))
			habitDay.meditate = true
		if (line.includes(DRINK_MARK) && line.includes(DONE_MARK))
			habitDay.drink = true
		if (line.includes(STRETCH_MARK) && line.includes(DONE_MARK))
			habitDay.stretch = true
		if (line.includes(EAT_MARK) && line.includes(DONE_MARK))
			habitDay.eat = true
		if (line.includes(CLEAN_MARK) && line.includes(DONE_MARK))
			habitDay.clean = true

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
		if (habitDay[habit]) {
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

function logStreaks(habitDays: HabitDay[]) {
	let today = new Date()
	let lastHabitDay = habitDays[habitDays.length - 1]
	let todayDone: boolean = true
	if (lastHabitDay.day.toDateString() !== today.toDateString()) {
		console.log(`🚨 Tu n'as pas fait ton entrée aujourd'hui!`)
		todayDone = false
	}
	let eatStreak = countStreak(habitDays, 'eat')
	let drinkStreak = countStreak(habitDays, 'drink')
	let cleanStreak = countStreak(habitDays, 'clean')
	let meditateStreak = countStreak(habitDays, 'meditate')
	let stretchStreak = countStreak(habitDays, 'stretch')

	// console.log(`📅 Last entry: ${lastHabitDay.day.toDateString()}`)
	console.log(`🍚 Eat streak:\t\t${eatStreak.streak} (max: ${eatStreak.maxStreak})\t(today: ${todayDone && lastHabitDay.eat ? '🎉' : '🕒'})`)
	console.log(`💧 Drink streak:\t${drinkStreak.streak} (max: ${drinkStreak.maxStreak})\t(today: ${todayDone && lastHabitDay.drink ? '🎉' : '🕒'})`)
	console.log(`🧹 Clean streak:\t${cleanStreak.streak} (max: ${cleanStreak.maxStreak})\t(today: ${todayDone && lastHabitDay.clean ? '🎉' : '🕒'})`)
	console.log(`🧘 Meditate streak:\t${meditateStreak.streak} (max: ${meditateStreak.maxStreak})\t(today: ${todayDone && lastHabitDay.meditate ? '🎉' : '🕒'})`)
	console.log(`🤸 Stretch streak:\t${stretchStreak.streak} (max: ${stretchStreak.maxStreak})\t(today: ${todayDone && lastHabitDay.stretch ? '🎉' : '🕒'})`)

	// console.log(`- 🍚 Eat streak: ${}\t(today: ${todayDone && lastHabitDay.eat ? '🎉' : '🕒'})`)
	// console.log(`- 💧 Drink streak: ${countStreak(habitDays, 'drink')}\t(today: ${todayDone && lastHabitDay.drink ? '🎉' : '🕒'})`)
	// console.log(`- 🧹 Clean streak: ${countStreak(habitDays, 'clean')}\t(today: ${todayDone && lastHabitDay.clean ? '🎉' : '🕒'})`)
	// console.log(`- 🧘 Meditate streak: ${countStreak(habitDays, 'meditate')}\t(today: ${todayDone && lastHabitDay.meditate ? '🎉' : '🕒'})`)
	// console.log(`- 🤸 Stretch streak: ${countStreak(habitDays, 'stretch')}\t(today: ${todayDone && lastHabitDay.stretch ? '🎉' : '🕒'})`)
}

function main() {
	let habitDays: HabitDay[] = getHabitDays()
	logStreaks(habitDays)
}

main()
