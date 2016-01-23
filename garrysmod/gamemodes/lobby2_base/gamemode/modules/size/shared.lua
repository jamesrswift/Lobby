--[[-----------------------------------------------------------

	██╗      ██████╗ ██████╗ ██████╗ ██╗   ██╗    ██████╗ 
	██║     ██╔═══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚════██╗
	██║     ██║   ██║██████╔╝██████╔╝ ╚████╔╝      █████╔╝
	██║     ██║   ██║██╔══██╗██╔══██╗  ╚██╔╝      ██╔═══╝ 
	███████╗╚██████╔╝██████╔╝██████╔╝   ██║       ███████╗
	╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝    ╚═╝       ╚══════╝

	
	Copyright (c) James Swift, Alex Swift, ULX, 2015
	
-----------------------------------------------------------]]--

Module.Sizing = { }

Module.Sizing.Default = {

	StandingHull = {
		Minimum = Vector( -16, -16, 00 ),
		Maximum = Vector(  16,  16, 72 ),
	},
	
	DuckingHull = {
		Minimum = Vector( -16, -16, 00 ),
		Maximum = Vector(  16,  16, 36 ),
	},
	
	JumpPower 	= 160,
	StepSize 	= 18,
	
	MaxStepSize = 500,
	MaxHullScale = 3,
	
	RunSpeed 	= 500,
	WalkSpeed 	= 250,
	Scale 		= Vector( 0, 0, 0 ),
	ViewOffset 	= Vector( 0, 0, 64 ),
	ViewOffsetDuck 	= Vector( 0, 0, 28 ),
	
}