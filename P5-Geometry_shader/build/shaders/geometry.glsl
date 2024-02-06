#version 400 core
layout(lines) in;
layout(line_strip, max_vertices = 146) out;

in VertexData 
{
    vec3 color;
} extra_data[];

out vec3 color_f;

void main() 
{
    const int n = 1; // итерация
    
    vec4 p1 = gl_in[0].gl_Position; // начальная точка
    vec4 p2 = gl_in[1].gl_Position; // конечная точка
    vec3 c1 = extra_data[0].color; // начальный цвет
    vec3 c2 = extra_data[1].color; // конечный цвет
    
    float scale = 1.; // размер
    float d = 0.; // смещение
    float s = 2.; // размер стороны
    int N = 1; // количество квадратов на стороне
    vec4 pij = vec4(0, 0, 0, 0);
    
    for (int k = 0; k < n; k++) // счетчик по итерации
    {
        for (int i = 0; i < N; i++) // проходим по квадратам
        {
            for (int j = 0; j < N; j++) // проходим по квадратам
            {
                pij.xy = vec2(d + i * s, d + j * s); // определение координаты центра у каждого квадрата
                gl_Position = pij + p1; // абсолютная позиция
                gl_Position.xy *= scale;
                color_f = c1;
                EmitVertex();
                gl_Position = p2 + pij; // абсолютная позиция
                gl_Position.xy *= scale;
                color_f = c2;
                EmitVertex();
                EndPrimitive();
            }
        }
        N *= 2; // на каждой итерации кол-во увеличивается
        s /= 2; // уменьшается размер в два раза каждую итерацию
        d -= s / 2; // изменение координаты центра у следующего квадрата

        // изменение координат концов относительно размера квадрата
        p1.xy /= 2; 
        p2.xy /= 2; 
    }
}
//\0