class_name MedicineCost
extends DailyCost

enum HealthState {
	SICK,
	WORSENING,
	SEVERE,
	CRITICAL
}

class MedicineData:
	var appeared: bool = false
	var cured: bool = false
	var status: HealthState

const priceList = [15, 18, 22, 30]
const colorsList: Array[Color] = [
	Color("e5e500ff"),
	Color("ff7f00ff"),
	Color("ff3e00ff"),
	Color("ff0000ff")
] 

var appear_week: int = 2

func _init() -> void:
	name = "Medicine"
	amount = priceList[0]
	tooltip = true
	
	if !RunData.cost_states.has("medicine"):
		RunData.cost_states["medicine"] = MedicineData.new()
		RunData.cost_states["medicine"].cured = false
		RunData.cost_states["medicine"].status = HealthState.SICK
	
	optional = _get_data().status != HealthState.CRITICAL
	
	if can_appear() or should_appear():
		RunData.cost_states["medicine"].appeared = true

func can_appear() -> bool:
	return RunData.current_week == appear_week and !_get_data().cured

func should_appear() -> bool:
	var already_appeared: bool =_get_data().appeared
	var is_cured: bool = _get_data().cured
	var on_appear_deadline: bool = (RunData.current_week == appear_week and RunData.current_day >= 3 and !already_appeared)
	
	return (already_appeared or on_appear_deadline) and !is_cured

func calculate_cost() -> int:
	return priceList[_get_data().status]

func on_pay():
	RunData.cost_states["medicine"].cured = true

func on_skip():
	RunData.cost_states["medicine"].status = min(
		HealthState.CRITICAL,
		_get_data().status + 1
	)

func get_description() -> String:
	var _status = _get_data().status
	
	return "Status: [color=%s]%s (%s/4)" % [colorsList[_status].to_html(false),(HealthState.find_key(_status) as String).to_pascal_case(), _get_data().status + 1]

func _get_data() -> MedicineData:
	return RunData.cost_states["medicine"]
