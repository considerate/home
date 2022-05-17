{
  services = {
    printing = {
      enable = true;
      browsing = true;

    };
    avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
}
