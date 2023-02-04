
# #define PI 3.14159265358979323846

# static const char* basis[] = { "1","e0","e1","e2","e01","e20","e12","e012" };

from std/math import sqrt

type 
    PGA2D* = array[8, float64]

proc `~`* (a:PGA2D):PGA2D =
    result[0] =  a[0]
    result[1] =  a[1]
    result[2] =  a[2]
    result[3] =  a[3]
    result[4] = -a[4]
    result[5] = -a[5]
    result[6] = -a[6]
    result[7] = -a[7]

proc `!`* (a:PGA2D):PGA2D = 
    result[0] = a[7]
    result[1] = a[6]
    result[2] = a[5]
    result[3] = a[4]
    result[4] = a[3]
    result[5] = a[2]
    result[6] = a[1]
    result[7] = a[0]

proc conjugate* (a:PGA2D):PGA2D =
    result[0] =  a[0]
    result[1] = -a[1]
    result[2] = -a[2]
    result[3] = -a[3]
    result[4] = -a[4]
    result[5] = -a[5]
    result[6] = -a[6]
    result[7] =  a[7]

proc involute* (a:PGA2D):PGA2D =
    result[0] =  a[0]
    result[1] = -a[1]
    result[2] = -a[2]
    result[3] = -a[3]
    result[4] =  a[4]
    result[5] =  a[5]
    result[6] =  a[6]
    result[7] = -a[7]

proc `*`* (a:PGA2D, b:PGA2D):PGA2D =
    result[0] = b[0]*a[0]+b[2]*a[2]+b[3]*a[3]-b[6]*a[6];
    result[1] = b[1]*a[0]+b[0]*a[1]-b[4]*a[2]+b[5]*a[3]+b[2]*a[4]-b[3]*a[5]-b[7]*a[6]-b[6]*a[7];
    result[2] = b[2]*a[0]+b[0]*a[2]-b[6]*a[3]+b[3]*a[6];
    result[3] = b[3]*a[0]+b[6]*a[2]+b[0]*a[3]-b[2]*a[6];
    result[4] = b[4]*a[0]+b[2]*a[1]-b[1]*a[2]+b[7]*a[3]+b[0]*a[4]+b[6]*a[5]-b[5]*a[6]+b[3]*a[7];
    result[5] = b[5]*a[0]-b[3]*a[1]+b[7]*a[2]+b[1]*a[3]-b[6]*a[4]+b[0]*a[5]+b[4]*a[6]+b[2]*a[7];
    result[6] = b[6]*a[0]+b[3]*a[2]-b[2]*a[3]+b[0]*a[6];
    result[7] = b[7]*a[0]+b[6]*a[1]+b[5]*a[2]+b[4]*a[3]+b[3]*a[4]+b[2]*a[5]+b[1]*a[6]+b[0]*a[7];

proc `^`* (a:PGA2D, b:PGA2D):PGA2D =
    result[0] = b[0]*a[0];
    result[1] = b[1]*a[0]+b[0]*a[1];
    result[2] = b[2]*a[0]+b[0]*a[2];
    result[3] = b[3]*a[0]+b[0]*a[3];
    result[4] = b[4]*a[0]+b[2]*a[1]-b[1]*a[2]+b[0]*a[4];
    result[5] = b[5]*a[0]-b[3]*a[1]+b[1]*a[3]+b[0]*a[5];
    result[6] = b[6]*a[0]+b[3]*a[2]-b[2]*a[3]+b[0]*a[6];
    result[7] = b[7]*a[0]+b[6]*a[1]+b[5]*a[2]+b[4]*a[3]+b[3]*a[4]+b[2]*a[5]+b[1]*a[6]+b[0]*a[7];

proc `&`* (a:PGA2D, b:PGA2D):PGA2D =
    result[7] = 1*(a[7]*b[7]);
    result[6] = 1*(a[6]*b[7]+a[7]*b[6]);
    result[5] = 1*(a[5]*b[7]+a[7]*b[5]);
    result[4] = 1*(a[4]*b[7]+a[7]*b[4]);
    result[3] = 1*(a[3]*b[7]+a[5]*b[6]-a[6]*b[5]+a[7]*b[3]);
    result[2] = 1*(a[2]*b[7]-a[4]*b[6]+a[6]*b[4]+a[7]*b[2]);
    result[1] = 1*(a[1]*b[7]+a[4]*b[5]-a[5]*b[4]+a[7]*b[1]);
    result[0] = 1*(a[0]*b[7]+a[1]*b[6]+a[2]*b[5]+a[3]*b[4]+a[4]*b[3]+a[5]*b[2]+a[6]*b[1]+a[7]*b[0]);

proc `|`* (a:PGA2D, b:PGA2D):PGA2D =
    result[0] = b[0]*a[0]+b[2]*a[2]+b[3]*a[3]-b[6]*a[6];
    result[1] = b[1]*a[0]+b[0]*a[1]-b[4]*a[2]+b[5]*a[3]+b[2]*a[4]-b[3]*a[5]-b[7]*a[6]-b[6]*a[7];
    result[2] = b[2]*a[0]+b[0]*a[2]-b[6]*a[3]+b[3]*a[6];
    result[3] = b[3]*a[0]+b[6]*a[2]+b[0]*a[3]-b[2]*a[6];
    result[4] = b[4]*a[0]+b[7]*a[3]+b[0]*a[4]+b[3]*a[7];
    result[5] = b[5]*a[0]+b[7]*a[2]+b[0]*a[5]+b[2]*a[7];
    result[6] = b[6]*a[0]+b[0]*a[6];
    result[7] = b[7]*a[0]+b[0]*a[7];

proc `+`* (a:PGA2D, b:PGA2D):PGA2D =
    result[0] = a[0]+b[0]
    result[1] = a[1]+b[1]
    result[2] = a[2]+b[2]
    result[3] = a[3]+b[3]
    result[4] = a[4]+b[4]
    result[5] = a[5]+b[5]
    result[6] = a[6]+b[6]
    result[7] = a[7]+b[7]

proc `-`* (a:PGA2D, b:PGA2D):PGA2D =
    result[0] = a[0]-b[0]
    result[1] = a[1]-b[1]
    result[2] = a[2]-b[2]
    result[3] = a[3]-b[3]
    result[4] = a[4]-b[4]
    result[5] = a[5]-b[5]
    result[6] = a[6]-b[6]
    result[7] = a[7]-b[7]

proc `*`* (a:PGA2D, s:float64):PGA2D =
    result[0] = a[0]*s
    result[1] = a[1]*s
    result[2] = a[2]*s
    result[3] = a[3]*s
    result[4] = a[4]*s
    result[5] = a[5]*s
    result[6] = a[6]*s
    result[7] = a[7]*s

proc `*`* (s:float64,a:PGA2D):PGA2D = a*s

proc `+`* (a:PGA2D, s:float64):PGA2D =
    result[0] = a[0]+s
    result[1] = a[1]
    result[2] = a[2]
    result[3] = a[3]
    result[4] = a[4]
    result[5] = a[5]
    result[6] = a[6]
    result[7] = a[7]
proc `+`* (s:float64, a:PGA2D):PGA2D = a+s

proc `-`* (a:PGA2D, s:float64):PGA2D =
    result[0] = a[0]-s
    result[1] = a[1]
    result[2] = a[2]
    result[3] = a[3]
    result[4] = a[4]
    result[5] = a[5]
    result[6] = a[6]
    result[7] = a[7]

proc `-`* (s:float64, a:PGA2D):PGA2D =
    result[0] = s-a[0]
    result[1] =  -a[1]
    result[2] =  -a[2]
    result[3] =  -a[3]
    result[4] =  -a[4]
    result[5] =  -a[5]
    result[6] =  -a[6]
    result[7] =  -a[7]


proc norm(a:PGA2D):float64 = sqrt(abs(conjugate(a)[0]))

proc inorm(a:PGA2D):float64 = norm(!a)

proc normalized(a:PGA2D):PGA2D = a*(1.0/norm(a))

proc point*(x,y:float64):PGA2D   = [ 0.0, 0.0, 0.0, 0.0,   y,   x, 1.0, 0.0]
proc line* (a,b,c:float64):PGA2D = [ 0.0,   c,   a,   b, 0.0, 0.0, 0.0, 0.0]

let 
    e0*  :PGA2D = [0.0,1.0,0.0,0.0,0.0,0.0,0.0,0.0]
    e1*  :PGA2D = [0.0,0.0,1.0,0.0,0.0,0.0,0.0,0.0]
    e2*  :PGA2D = [0.0,0.0,0.0,1.0,0.0,0.0,0.0,0.0]
    e01* :PGA2D = [0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0]
    e20* :PGA2D = [0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0]
    e12* :PGA2D = [0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0]
    e012*:PGA2D = [0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0]


var 
    a:PGA2D = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
    b:PGA2D = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8]
    s:float64 = 0.5

echo "(a):"             & $(a) 
echo "(~a):"            & $(~a)
echo "(!a):"            & $(!a)
echo "(conjugate a):"   & $(conjugate a)
echo "(involute a):"    & $(involute a)
echo "(a*b):"           & $(a*b)
echo "(a^b):"           & $(a^b)
echo "(a&b):"           & $(a&b)
echo "(a|b):"           & $(a|b)
echo "(a+b):"           & $(a+b)
echo "(a-b):"           & $(a-b)
echo "(a+b):"           & $(a+b)
echo "(a*s):"           & $(a*s)
echo "(s*a):"           & $(s*a)
echo "(a+s):"           & $(a+s)
echo "(s+a):"           & $(s+a)
echo "(a-s):"           & $(a-s)
echo "(s-a):"           & $(s-a)
echo "(norm(a)):"       & $(norm(a))
echo "(inorm(a)):"      & $(inorm(a))
echo "(normalized(a)):" & $(normalized(a))

var
    l = line(1.0, 1.0, 1.0)
    p = point(1.0, 1.0)
    pr = normalized((p|l)*(~l))
echo "line:"        & $(l)
echo "point:"       & $(p)
echo "projection :" & $(pr)




# // 3D Projective Geometric Algebra
# // Written by a generator written by enki.
# #include <stdio.h>
# #include <cmath>
# #include <array>



# int main (int argc, char **argv) {
  
#   printf("e0*e0         : "); (e0*e0).log();
#   printf("pss           : "); e012.log();
#   printf("pss*pss       : "); (e012*e012).log();

#   return 0;
# }