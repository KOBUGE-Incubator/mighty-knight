extends Node2D

const tile = preload("res://assets/tiles/tile.tscn")
const coin = preload("res://assets/items/coin.tscn")
const zombie = preload("res://assets/zombie/zombie.tscn")
const sword = preload("res://assets/swords/sword.tscn")
const spikes = preload("res://assets/spikes/spikes.tscn")
const life = preload("res://assets/misc/life.tscn")
const points = preload("res://assets/misc/points.tscn")
onready var W_SIZE = OS.get_window_size()
onready var places = [592,464,336,208]
var coins = 0
var coins_life = 0
var lifes = 3
var tile_z = -2

var active_zombies = false
var active_spikes = false

onready var config = ConfigFile.new()
var highscore = 0

func _ready():
	config.load("user://settings.cfg")
	highscore = config.get_value("general","highscore",0)
	randomize()
	update_lifes()
	init_tiles()
	
func init_tiles():
	var amount = 14
	for i in range(amount):
		var tile_new = tile.instance()
		tile_new.set_pos(Vector2((i*126)+64,592+64))
		tile_new.set_z(-1)
		if i == amount-1:
			tile_new.get_node("sprites").set_frame(2)
		else:
			tile_new.get_node("sprites").set_frame(1)
		add_child(tile_new)


func create_random():
	var amount = (randi() % 3)+5
	var rand_y = randi() % places.size()
	for i in range(amount):
		var add_coin = randi() % 2
		if add_coin == 0:
			var coin_new = coin.instance()
			coin_new.set_pos(Vector2(get_node("knight").get_pos().x+1100+i*128,places[rand_y]-64))
			add_child(coin_new)
		var tile_new = tile.instance()
		tile_z -= 1
		tile_new.set_z(tile_z)
		tile_new.set_pos(Vector2(get_node("knight").get_pos().x+1100+i*128,places[rand_y]+64))
		if i == 0:
			tile_new.get_node("sprites").set_frame(0)
		elif i == amount-1:
			tile_new.get_node("sprites").set_frame(2)
			if active_zombies:
				var add_zombie = randi() % 2
				if add_zombie == 0:
					var zombie_new = zombie.instance()
					zombie_new.set_pos(Vector2(get_node("knight").get_pos().x+1100+i*128,places[rand_y]-64))
					add_child(zombie_new)
		else:
			if active_spikes:
				var add_spikes = randi() % 10
				if add_spikes == 0:
					var spikes_new = spikes.instance()
					spikes_new.set_pos(Vector2(get_node("knight").get_pos().x+1100+i*128,places[rand_y]-35))
					add_child(spikes_new)
			tile_new.get_node("sprites").set_frame(1)
		add_child(tile_new)

func _on_restart_pressed():
	get_tree().change_scene("res://main_menu.tscn")


func _on_random_tile_timeout():
	create_random()

func _on_random_enemy_timeout():
	var amount = randi() % 4
	for i in range(amount):
		var sword_new = sword.instance()
		sword_new.set_pos(Vector2(get_node("knight").get_pos().x+400+i*128,-64))
		add_child(sword_new)
	
func remove_life():
	lifes -= 1
	update_lifes()
	
func add_life():
	lifes += 1
	update_lifes()

func update_lifes():
	if lifes >= 0:
		for c in get_node("gui/lifes").get_children():
			c.queue_free()
		for i in range(lifes):
			var life_new = life.instance()
			life_new.set_pos(Vector2(128+i*40,32))
			get_node("gui/lifes").add_child(life_new)
	else:
		if coins > highscore:
			config.set_value("general","highscore",coins)
			config.save("user://settings.cfg")
		get_node("knight").dead = true
		get_node("restart").start()
		
func add_points(amount,pos):
	var point_new = points.instance()
	point_new.get_node("label").set_text("+"+str(amount))
	point_new.set_pos(pos)
	add_child(point_new)
	coins += amount
	coins_life += amount
	if coins_life >= 100:
		add_life()
		coins_life -= 100
	get_node("gui/coins").set_text(str(coins))

func _on_activate_zombies_timeout():
	active_zombies = true

func _on_activate_swords_timeout():
	get_node("random_sword").start()

func _on_activate_spikes_timeout():
	active_spikes = true


func _on_restart_timeout():
	get_tree().reload_current_scene()
