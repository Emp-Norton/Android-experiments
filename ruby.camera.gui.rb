# frozen_string_literal: true

# Required libraries
require 'tk'
require 'tkextlib'
require 'open3'

# Class definition for the GUI
class CameraGUI
  # Initialize the GUI
  def initialize
    # Create the main window
    @root = TkRoot.new

    # Create a label to hold the camera feed
    @camera_label = Tk::Label.new(@root)
    @camera_label.pack

    # Create a button to quit the application
    @quit_button = Tk::Button.new(@root) { text 'Quit' }
    @quit_button.command { quit }
    @quit_button.pack

    # Create a button to start recording
    @record_button = Tk::Button.new(@root) { text 'Record' }
    @record_button.command { record }
    @record_button.pack

    # Create a button to select an overlay
    @overlay_button = Tk::Button.new(@root) { text 'Select Overlay' }
    @overlay_button.command { select_overlay }
    @overlay_button.pack

    # Start the camera feed
    start_camera
  end

  # Start the camera feed
  def start_camera
    # Use raspivid to capture the camera feed and pipe it to mplayer
    # which will display the feed in the GUI
    @camera_pid = spawn('raspivid -t 0 -w 640 -h 480 -fps 30 -b 2000000 -o - | mplayer -')

    # Wait for the camera feed to start
    sleep 1

    # Get the window ID of the mplayer window
    @window_id = `xdotool search --onlyvisible --name "mplayer"`.strip

    # Embed the mplayer window into the GUI
    Tk::TkCmd.eval("wm manage #{@window_id}")
    Tk::TkCmd.eval("wm transient #{@window_id} #{@root.id}")
    Tk::TkCmd.eval("wm withdraw #{@window_id}")
    Tk::TkCmd.eval("wm deiconify #{@window_id}")
    Tk::TkCmd.eval("wm reparent #{@window_id} #{@root.id}")
  end

  # Quit the application
  def quit
    # Kill the camera feed process
    Process.kill('TERM', @camera_pid)

    # Exit the application
    exit
  end

  # Start recording
  def record
    # Use raspivid to record the camera feed
    @record_pid = spawn('raspivid -t 0 -w 640 -h 480 -fps 30 -b 2000000 -o video.h264')
  end

  # Select an overlay
  def select_overlay
    # Create a file dialog to select an overlay
    dialog = Tk::FileDialog.new(@root)
    @overlay_file = dialog.show

    # Use raspivid to overlay the selected file on the camera feed
    @overlay_pid = spawn("raspivid -t 0 -w 640 -h 480 -fps 30 -b 2000000 -o - | mplayer -vf #{@overlay_file} -")
  end

  # Run the GUI event loop
  def run
    @root.mainloop
  end
end

# Create an instance of the GUI and run it
gui = CameraGUI.new
gui.run

