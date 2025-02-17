//
//  Gradient.fsh
//  Donmani
//
//  Created by 문종식 on 2/16/25.
//

void main() {
    vec4 color = texture2D(u_texture, v_tex_coord);
    float t = (v_tex_coord.x - v_tex_coord.y + 1.0) / 2.0;
    vec4 finalColor;
    if (t <= 0.25) {
        finalColor = startColor;
    } else if (t <= 0.75) {
        float ratio = (t - 0.25) / 0.5;
        finalColor = mix(startColor, endColor, ratio);
    } else {
        finalColor = endColor;
    }
    gl_FragColor = color * finalColor;
}
