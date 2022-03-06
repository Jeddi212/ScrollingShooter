-- Configuration
-- http://www.osmstudios.com/tutorials/your-first-love2d-game-in-200-lines-part-1-of-3
function love.conf(t)
    t.title = "Scrolling Shooter Tutorial" -- The title of the window the game is in (string)
	t.version = "11.4"         -- The LÖVE version this game was made for (string)
	t.window.width = 480        -- we want our game to be long and thin.
	t.window.height = 710

	-- For Windows debugging
	t.console = true -- Change to false for releasing game
end