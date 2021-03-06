package com.AfvanJaffer.easy;


import com.AfvanJaffer.easy.design.Design;
import com.AfvanJaffer.easy.printer.Printer;
import com.AfvanJaffer.easy.settings.Style;
import com.AfvanJaffer.easy.shape.Shape;
import com.AfvanJaffer.easy.ultimaker.Ultimaker;
import processing.core.PApplet;
import processing.core.PConstants;


final public class Application extends PApplet
{

	// Classname
	final public static String NAME = "com.AfvanJaffer.easy.Application";


	// Properties
	private ApplicationView view;
	private Shape shape;
	private Ultimaker ultimaker;
	private Design design;
	private Printer printer;
	private boolean designMode = true;


	public void settings()
	{
		size(Style.WIDTH, Style.HEIGHT, PConstants.P2D);
		pixelDensity(displayDensity());
		smooth(4);
    }


	public void setup()
	{
		// Set framerate and title
		surface.setFrameRate(60);
		surface.setTitle("easy");

		// Create frame and listen to switch
		view = new ApplicationView(this);
		view.getToggle().onClick(() -> {
			designMode = !designMode;
			view.getToggle().setLabel(designMode ? "PRINT MODE" : "DESIGN MODE");
		});

		// Create the controllers
		shape = new Shape(this);
		ultimaker = new Ultimaker(this);
		design = new Design(this, shape);
		printer = new Printer(this, shape, ultimaker);
	}


	public void draw()
	{
		// Draw view
		view.draw();

		// Update controllers
		shape.update();
		ultimaker.update();

		// Only update the controllers that are visible,
		// so we don't use extra CPU power to update invisible parts
		if (designMode) {
			design.update();
		} else {
			printer.update();
		}
	}

}
