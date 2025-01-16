package database

import (
	"errors"
	"webserver/models"

	"gorm.io/gorm"
)

// GetUserByID retrieves a single user from the database by their ID
func GetUserByID(id uint) (*models.User, error) {
	var user models.User
	result := DB.First(&user, id)

	if result.Error != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, result.Error
	}

	return &user, nil
}
