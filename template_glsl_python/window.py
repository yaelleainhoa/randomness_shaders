import moderngl_window as mglw

class App(mglw.WindowConfig):
    window_size = 800, 450
    resource_dir = 'shaders'

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.quad = mglw.geometry.quad_fs()

        self.prog = self.load_program(vertex_shader='vertex/basic_vs.glsl', 
                                        fragment_shader='fragment/wood.glsl')
        
        self.set_uniform('resolution', self.window_size)


    def render(self, time, frame_time):
        self.ctx.clear()
        self.set_uniform('time', time)
        self.quad.render(self.prog)

    def set_uniform(self, u_name, u_value):
        try:
            self.prog[u_name] = u_value
        except KeyError:
            print(f'_uniform:{u_name}-not used in shader')

if __name__ == '__main__':
    mglw.run_window_config(App)