package com.AfvanJaffer.easy;


import com.AfvanJaffer.easy.controlP5.GuiContainer;
import com.AfvanJaffer.easy.controlP5.GuiButton;
import com.AfvanJaffer.easy.settings.Style;
import com.AfvanJaffer.easy.utils.Gui;
import processing.core.PImage;


final public class ApplicationView
{

	// Properties
	private Application app;
	private GuiContainer cp5;
	private PImage img;
	private GuiButton toggle;


	public ApplicationView(Application app)
	{
		// Store references
		this.app = app;

		// Load logo
		img = app.loadImage("data/logo@" + this.app.displayDensity() + "x.png");
		img.pixelDensity = this.app.displayDensity();

		// Create GUI layer
		cp5 = new GuiContainer(app);
		cp5.setAutoDraw(false);

		// Create buttons
		toggle = Gui.createButton(cp5, false, "PRINT MODE", Style.WIDTH - 120, 20, 100, 30);
		toggle.setColorActive(0xFFFF0044);
		toggle.setColorForeground(0xFFFF0044);
		toggle.setColorBackground(0xFFFF0044);
	}


	public GuiButton getToggle()
	{
		return toggle;
	}


	public void draw()
	{
		// Draw background
		app.background(0, 0, 0);

		// Draw logo
		app.image(img, 0, 0);

		// Update GUI elements
		cp5.draw();
	}

}
