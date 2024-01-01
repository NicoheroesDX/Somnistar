extends Node

class_name Page

var page: String = ""
var content: String = ""

func _init(i_page: String = "", i_content: String = ""):
	page = i_page
	content = i_content
