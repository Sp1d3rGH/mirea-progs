using HorizonSideRobots

function main(infile::String)
    r = Robot(infile, animate=true)
    move!(r::Robot, Nord::HorizonSide)
end