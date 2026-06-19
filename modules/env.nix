{ ... }:

{
  environment.variables = {
    _JAVA_OPTIONS =
      "--add-opens=java.desktop/sun.awt.X11=ALL-UNNAMED --add-opens=java.desktop/java.awt=ALL-UNNAMED";

    # future variables
    EDITOR = "nano";
    BROWSER = "firefox";
  };
}
