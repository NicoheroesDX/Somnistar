extends Node

var speed = 0
var collectedLight = 10000

signal update_collected_light_signal(new_light_amount, old_light_amount)

func update_speed(newGlobalSpeed):
	speed = newGlobalSpeed;

func change_collected_light(lightAmountOperation):
	var oldLightAmount = collectedLight
	var newLightAmount = collectedLight + lightAmountOperation
	if newLightAmount < 0:
		newLightAmount = 0;
	collectedLight = newLightAmount;
	update_collected_light_signal.emit(newLightAmount, oldLightAmount)
