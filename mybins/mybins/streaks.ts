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

const MEDITATE_MARK = '🧘'
const STRETCH_MARK = '🤸'
const DRINK_MARK = '💧'
const EAT_MARK = '🍚'
const CLEAN_MARK = '🧹'

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

function countStreaks(habitDays: HabitDay[], habit: string) {
	let streak = 0

	habitDays.forEach((habitDay) => {
		if (habitDay[habit]) {
			streak++
		} else {
			streak = 0
		}
	})
	return streak
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
	console.log(`- 🍚 Eat streak: ${countStreaks(habitDays, 'eat')}\t(today: ${todayDone && lastHabitDay.eat ? '🎉' : '🕒'})`)
	console.log(`- 💧 Drink streak: ${countStreaks(habitDays, 'drink')}\t(today: ${todayDone && lastHabitDay.drink ? '🎉' : '🕒'})`)
	console.log(`- 🧹 Clean streak: ${countStreaks(habitDays, 'clean')}\t(today: ${todayDone && lastHabitDay.clean ? '🎉' : '🕒'})`)
	console.log(`- 🧘 Meditate streak: ${countStreaks(habitDays, 'meditate')}\t(today: ${todayDone && lastHabitDay.meditate ? '🎉' : '🕒'})`)
	console.log(`- 🤸 Stretch streak: ${countStreaks(habitDays, 'stretch')}\t(today: ${todayDone && lastHabitDay.stretch ? '🎉' : '🕒'})`)
}

function main() {
	let habitDays: HabitDay[] = getHabitDays()
	logStreaks(habitDays)
}

main()
