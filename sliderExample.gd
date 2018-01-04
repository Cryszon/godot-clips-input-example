extends Control

onready var clipContainer = find_node("clipContainer")
onready var slider = find_node("slider")
onready var paginator = find_node("paginator")
onready var prevPageButton = paginator.get_node("prevPage")
onready var nextPageButton = paginator.get_node("nextPage")
onready var currentPageLabel = paginator.find_node("currentPage")
onready var pageCountLabel = paginator.find_node("maxPages")

var curPage = 1
var tween = Tween.new()

func _ready():
	add_child(tween)
	
	find_node("setClipContents").connect("toggled", self, "setClipProp", ["rect_clip_content"])
	find_node("setClipInput").connect("toggled", self, "setClipProp", ["rect_clips_input"])
	
	prevPageButton.connect("pressed", self, "movePages", [-1])
	nextPageButton.connect("pressed", self, "movePages", [1])
	
	updatePaginator()
	
	for grid in slider.get_children():
		for item in grid.get_children():
			item.get_node("TextureButton").connect("pressed", self, "onClickItem", [item])

func setClipProp(value, prop):
	clipContainer.set(prop, value)

func getPageCount():
	return slider.get_child_count()

func updatePaginator():
	currentPageLabel.set_text(str(curPage))
	pageCountLabel.set_text(str(getPageCount()))
	prevPageButton.set_disabled(curPage <= 1)
	nextPageButton.set_disabled(curPage >= getPageCount())

func movePages(offset):
	var targetPage = curPage + offset
	var pageWidth = clipContainer.get_size().x
	var sourcePos = slider.rect_position
	var targetPos = Vector2(-pageWidth * (targetPage - 1), sourcePos.y)
	tween.stop_all()
	tween.interpolate_property(slider, "rect_position", sourcePos, targetPos, .2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	curPage = targetPage
	updatePaginator()

func onClickItem(item):
	print("Item clicked!")
	print(item)