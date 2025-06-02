public static class WheelTread {

  public static final WheelTread SPIKY = new WheelTread(0.8, 1.2);
  public static final WheelTread SMOOTH = new WheelTread(0.6, 1.0);
  
  private final float traction;
  private final float pointModifier;

  private WheelTread(float traction, float pointModifier) {
    this.traction = traction;
    this.pointModifier = pointModifier;
  }

  public float getTractionCoefficient() {
    return traction;
  }

  public float getPointModifier() {
    return pointModifier;
  }
}
