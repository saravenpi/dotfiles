package models

import "gorm.io/gorm"

type User struct {
	gorm.Model            // Adds ID, CreatedAt, UpdatedAt, and DeletedAt fields
	Username      string  `json:"username" gorm:"uniqueIndex"`
	Email         string  `json:"email" gorm:"uniqueIndex"`
	Password      string  `json:"password"`
}
