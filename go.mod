module github.com/meshery-extensions/tcslabs-academy

go 1.26.4

// Uncomment line below when testing local changes to the academy theme
// replace github.com/layer5io/academy-theme => ../academy-theme

replace github.com/FortAwesome/Font-Awesome v4.7.0+incompatible => github.com/FortAwesome/Font-Awesome v0.0.0-20241216213156-af620534bfc3

require (
	github.com/FortAwesome/Font-Awesome v4.7.0+incompatible // indirect
	github.com/layer5io/academy-theme v0.4.17 // indirect
	github.com/twbs/bootstrap v5.3.8+incompatible // indirect
)
