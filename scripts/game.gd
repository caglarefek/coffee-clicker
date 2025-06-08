extends Control

# === Variables ===

var bean_count: int = 0
var click_count: int = 1

var upgrade_cost: int = 10
var farmer_cost: int = 25
var speed_cost: int = 50

var upgrade_cost_multiplier: int = 1.5
var farmer_cost_multiplier: int = 1.6
var speed_cost_multiplier: int = 2.0

var farmer_count: int = 0
var base_farmer_interval: float = 5.0  # base seconds between auto gathers
var farmer_speed_multiplier: float = 1.0

# === Nodes ===

@onready var beans_label: Label = $LabelContainer/BeansLabel
@onready var click_label: Label = $LabelContainer/ClickLabel
@onready var farmer_label: Label = $LabelContainer/FarmerLabel
@onready var speed_label: Label = $LabelContainer/SpeedLabel

@onready var gather_button: Button = $ButtonContainer/GatherButton
@onready var upgrade_button: Button = $ButtonContainer/UpgradeButton
@onready var farmer_button: Button = $ButtonContainer/FarmerButton
@onready var speed_button: Button = $ButtonContainer/SpeedButton

@onready var farmer_timer = $FarmerTimer

# === Ready ===

func _ready():
	gather_button.pressed.connect(_on_click_button_pressed)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	farmer_button.pressed.connect(_on_farmer_button_pressed)
	speed_button.pressed.connect(_on_speed_button_pressed)
	
	farmer_timer.wait_time = base_farmer_interval / farmer_speed_multiplier
	update_ui()

# === Game Logic ===

func _on_click_button_pressed():
	bean_count += click_count
	
	update_ui()

func _on_upgrade_button_pressed():
	if bean_count >= upgrade_cost:
		bean_count -= upgrade_cost
		click_count += 1
		upgrade_cost = int(upgrade_cost * upgrade_cost_multiplier)
		
		update_ui()

func _on_farmer_button_pressed():
	if bean_count >= farmer_cost:
		bean_count -= farmer_cost
		farmer_count += 1
		farmer_cost = int(farmer_cost * farmer_cost_multiplier)
		
		update_ui()

func _on_speed_button_pressed():
	if bean_count >= speed_cost:
		bean_count -= speed_cost
		farmer_speed_multiplier *= 1.2
		speed_cost = int(speed_cost * speed_cost_multiplier)
		farmer_timer.wait_time = base_farmer_interval / farmer_speed_multiplier
		
		update_ui()

func farmer_timeout() -> void:
	var beans_gathered = farmer_count * click_count
	bean_count += beans_gathered
	
	update_ui()

# === UI Update ===

func update_ui():
	var multiplier = base_farmer_interval / farmer_timer.wait_time
	
	beans_label.text = "Beans: %d" % bean_count
	click_label.text = "Click: %d" % click_count
	farmer_label.text = "Farmers: %d" % farmer_count
	speed_label.text = "Speed: x%.2f" % multiplier
	
	upgrade_button.text = "UPGRADE - %d" % upgrade_cost
	farmer_button.text = "FARMER - %d" % farmer_cost
	speed_button.text = "SPEED - %d" % speed_cost
