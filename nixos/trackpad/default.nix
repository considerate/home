{
  # Configure touchpad with libinput
  services.xserver.libinput = {
    enable = true;
    mouse = {
      accelSpeed = "0.001";
      naturalScrolling = true;
    };
    touchpad = {
      accelSpeed = "0.001";
      buttonMapping = "1 2 3";
      disableWhileTyping = true;
      naturalScrolling = true;
      clickMethod = "buttonareas";
    };
  };
}
