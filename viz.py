import bpy
import sys

global selObj
global camTarget
mat = 'abs' # The material to use on the imported STL is called "abs"  
            # e.g. orange plastic with white gloss 
            # this is saved with as "F abs" so that it is saved with the blend file even
            # if the material isn't used

# load stl file			
def load_stl(file_path):
    global camTarget,selObj
    
    # load stl
    bpy.ops.import_mesh.stl(filepath=file_path)
    
    # select properly
    selObj = bpy.context.selected_objects[0]
    print('Selected object: ', selObj)
    bpy.ops.object.select_all(action='DESELECT')
    selObj.select = True
    
    # remove doubles and clean
    #py.ops.object.editmode_toggle()
    #bpy.ops.mesh.select_all(action='TOGGLE')
    #bpy.ops.mesh.remove_doubles(limit=0.0001)
    #bpy.ops.mesh.normals_make_consistent(inside=False)
    #bpy.ops.object.editmode_toggle()
	
    # set origin
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='BOUNDS')
    
    # place
    # d = selObj.dimensions
    # x = d[0]
    # y = d[1]
    # z = d[2]
    zDim = selObj.dimensions[2]
    print('Z dimension: ', zDim)
	
    # Translate (move) selected items half it's height upwards
    bpy.ops.transform.translate(value=(0,0,zDim/2.0))
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

    #selObj.location += Vector(1,1,0)

    # calculate camera target in the z axis
    camTarget = (0,0,zDim/3.0)
    print('Camera target: ', camTarget)
	
    # assign material
    selObj.material_slots.data.active_material = bpy.data.materials[mat]

def place_camera():
    global camTarget
	
    # place the camera, first get the object dimensions
    d = selObj.dimensions
    x = d[0]
    y = d[1]
    z = d[2]
	
    # scale z and y down with 25%
    max_dim = max(x * 0.75, y * 0.75, z)
    print('Max dimensions: ', max_dim)
	
    # place camera at the target calculated in the load_stl method
    bpy.data.objects['target'].location = camTarget
    cam = bpy.data.objects['Camera'].location.x = max_dim * 2.4

def render_image(image,gl=False,anim=False):
    # render image
    if gl:
        if anim:
            bpy.data.scenes['Scene'].render.filepath = "/tmp/"+selObj.name+"#"
            bpy.ops.render.opengl(animation=True)
        else:
            bpy.ops.render.opengl(write_still=True)
            bpy.data.images['Render Result'].save_render(filepath=image)
    else:
        if anim:
            bpy.data.scenes['Scene'].render.filepath = "/tmp/"+selObj.name+"#"
            bpy.ops.render.render(animation=True)
        else:
            bpy.ops.render.render(write_still=True)
            bpy.data.images['Render Result'].save_render(filepath=image)


# read the parameters from the command line			
image = sys.argv[-1]
stl = sys.argv[-2]
print('stl: ', stl)
print('image: ', image)

# run the methods
load_stl(stl)
place_camera()
render_image(image,gl=False)
#bpy.ops.object.delete()
