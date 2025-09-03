extends Scorer

@onready var desired_output_label: Label = %DesiredOutputLabel
@onready var output_label: Label = %OutputLabel

func is_met():
	return desired_output_label.text == output_label.text
