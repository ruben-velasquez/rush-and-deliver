class_name Package
extends Object

enum PackageProperty { NORMAL, HEAVY, FRAGILE, URGENT }

var goal: Area2D
var property: PackageProperty = PackageProperty.NORMAL
var reward: int = 1
var done: bool = false
