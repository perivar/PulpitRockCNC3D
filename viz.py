import bpy
import sys

global ob
global cam_target
mat = 'abs' # The material is "F abs"  

def load_stl(file_path):
    global cam_target,ob
    
	# load stl
    bpy.ops.import_mesh.stl(filepath=file_path)
    
	# select properly
    ob = bpy.context.selected_objects[0]
    print('Selected objects: ', ob)
    bpy.ops.object.select_all(action='DESELECT')
    ob.select = True
    
	# remove doubles and clean
    #py.ops.object.editmode_toggle()
    #bpy.ops.mesh.select_all(action='TOGGLE')
    #bpy.ops.mesh.remove_doubles(limit=0.0001)
    #bpy.ops.mesh.normals_make_consistent(inside=False)
    #bpy.ops.object.editmode_toggle()
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='BOUNDS')
    
	# place
	# d = ob.dimensions
    # x = d[0]
    # y = d[1]
    # z = d[2]
    z_dim = ob.dimensions[2]
    print('Z dimension: ', z_dim)
	
	# Translate (move) selected items
    bpy.ops.transform.translate(value=(0,0,z_dim/2.0))
	# Note this throws an error 'convertviewvec called in invalid context'

	# If you know where you are moving your object to:
	# import bpy
	#
	# context = bpy.context
	# obj = context.active_object 
	# obj.location = (1, 0, 0)  # accepts tupples,  use Vector if you are going to do calcs.

	# Similarly if you want to translate, ie move (1, 1, 0) from where it was:
	# import bpy
	# from mathutils import Vector
	# 
	# context = bpy.context
	# obj = context.active_object
	# obj.location += Vector([1, 1, 0])

	#ob.location += Vector(1,1,0)

    cam_target = (0,0,z_dim/3.0)
    print('Camera target: ', cam_target)
	
	# assign material
    ob.material_slots.data.active_material = bpy.data.materials[mat]

def place_camera():
    global cam_target
    max_dim = max(ob.dimensions[0] * 0.75, ob.dimensions[1] * 0.75, ob.dimensions[2])
    print('Max dimensions: ', max_dim)
    bpy.data.objects['target'].location = cam_target
    cam = bpy.data.objects['Camera'].location.x = max_dim * 2.4

def render_thumb(image,gl=False,anim=False):
    if gl:
        if anim:
            bpy.data.scenes['Scene'].render.filepath = "/tmp/"+ob.name+"#"
            bpy.ops.render.opengl(animation=True)
        else:
            bpy.ops.render.opengl(write_still=True)
            bpy.data.images['Render Result'].save_render(filepath=image)
    else:
        if anim:
            bpy.data.scenes['Scene'].render.filepath = "/tmp/"+ob.name+"#"
            bpy.ops.render.render(animation=True)
        else:
            bpy.ops.render.render(write_still=True)
            bpy.data.images['Render Result'].save_render(filepath=image)

image = sys.argv[-1]
stl = sys.argv[-2]
print(stl)
print(image)

load_stl(stl)
place_camera()
render_thumb(image,gl=False)
#bpy.ops.object.delete()