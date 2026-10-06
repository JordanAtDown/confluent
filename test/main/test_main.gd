extends GutTest

const MainScene := preload("res://src/main/main.tscn")


func test_main_scene_instantiates() -> void:
	var main: Node3D = add_child_autofree(MainScene.instantiate())
	assert_not_null(main, "la scène main doit s'instancier")
	assert_is(main, Node3D, "la racine de main est un Node3D")


func test_main_scene_has_a_camera() -> void:
	var main: Node3D = add_child_autofree(MainScene.instantiate())
	assert_is(main.get_node_or_null("Camera3D"), Camera3D, "main contient une Camera3D")


func test_main_scene_shows_hello_world() -> void:
	var main: Node3D = add_child_autofree(MainScene.instantiate())
	var label := main.get_node_or_null("HelloWorld") as Label3D
	assert_not_null(label, "main contient un Label3D nommé HelloWorld")
	assert_eq(label.text, "Hello World", "le label affiche le texte attendu")
