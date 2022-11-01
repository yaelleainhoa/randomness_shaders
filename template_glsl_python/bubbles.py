import moderngl_window as mglw
import numpy
from math import dist
from random import random

nb_cell_by_line = 10
w = 800
h = 450

def rand_pos(nb_cell, size):
    return random()*size*2/nb_cell_by_line-size+size*2*nb_cell/nb_cell_by_line


class Circle():
    def __init__(self, i, j):
        super().__init__()
        self.x = rand_pos(i, 0.88)
        self.y = rand_pos(j, 0.5)
        self.r = 0.01
        self.growing = True


    def grow(self):
        self.r+=0.0001

    def intersects(self,circle):
        if(dist([circle.x, circle.y], [self.x, self.y])>=circle.r+self.r):
            return False
        else:
            self.growing = False
            return True

    def nuplet(self):
        return (self.x, self.y, self.r)


class Circles():
    def __init__(self):
        self.circles = [0]*nb_cell_by_line*nb_cell_by_line
        for i in range(nb_cell_by_line):
            # x = 0#rand_pos(i, w)
            for j in range(nb_cell_by_line):
                # y = rand_pos(j, 0.5)
                self.circles[nb_cell_by_line*i+j] = Circle(i,j)


    def intersects(self, i,j):
        self.circles[i].intersects(self.circles[j])


    def nuplet(self, i):
        return self.circles[i].nuplet()

    def growing(self):
        growing = False
        for i in range(nb_cell_by_line*nb_cell_by_line):
            if self.circles[i].growing == True:
                self.circles[i].grow()
                growing = True
        return growing



class App(mglw.WindowConfig):
    window_size = w, h
    resource_dir = 'shaders'

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.quad = mglw.geometry.quad_fs()

        self.prog = self.load_program(vertex_shader='vertex/bubbles_vs.glsl', 
                                        fragment_shader='fragment/bubbles_fs.glsl')
        self.set_uniform('resolution', self.window_size)
        self.set_circles()

    def render(self, time, frame_time):
        self.ctx.clear()
        self.quad.render(self.prog)

    def set_uniform(self, u_name, u_value):
        try:
            self.prog[u_name] = u_value
        except KeyError:
            print(f'_uniform:{u_name}-not used in shader')


    def set_circles(self):
        self.circles = Circles()
        while(self.circles.growing()):
            for i in range(nb_cell_by_line*nb_cell_by_line):
                for j in range(nb_cell_by_line*nb_cell_by_line):
                    if(i!=j):
                        self.circles.intersects(i,j)
        circles = [(0,0,0)]*nb_cell_by_line*nb_cell_by_line
        for i in range(nb_cell_by_line*nb_cell_by_line):
            circles[i] = self.circles.nuplet(i)
        self.set_uniform('nb_circles', nb_cell_by_line*nb_cell_by_line)
        self.set_uniform('circles', circles)

if __name__ == '__main__':
    mglw.run_window_config(App)