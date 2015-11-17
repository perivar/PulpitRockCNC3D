import bpy
import sys

global selObj
global camTarget

# Material
# The material to use on the imported STL is called "abs"  
# e.g. orange plastic with white gloss 
# this is saved with as "F abs" so that it is saved with the blend file even
# if the material isn't used
#mat = 'abs'
#mat = 'stainless_steel'
mat = 'chrome'
#mat = 'plastic'

# load stl file			
def load_stl(file_path):
    global camTarget,selObj
    
    # load stl
    bpy.ops.import_mesh.stl(filepath=file_path)
    
    # select properly by deselection all and selecting again
    selObj = bpy.context.selected_objects[0]
    print('Selected object: ', selObj)
    # deselect all
    bpy.ops.object.select_all(action='DESELECT')
    # and select only the new object 
    selObj.select = True
    	
    # set origin so that the later transform (move) will be correct
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='BOUNDS')
    
    # place
    # d = selObj.dimensions
    # x = d[0]
    # y = d[1]
    # z = d[2]
    zDim = selObj.dimensions[2]
    print('Z dimension: ', zDim)
	
    # Translate (move) selected items half it's own height upwards
    bpy.ops.transform.translate(value=(0,0,zDim/2.0))
    # Note this throws an error 'convertViewVec: called in an invalid context'

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
	
    # scale x and y down with 25%
    max_dim = max(x * 0.75, y * 0.75, z)
    print('Max dimensions: ', max_dim)
	
    # point camera at the target calculated in the load_stl method
    # this require a special 'empty - target - sphere' element named 'target'
    bpy.data.objects['target'].location = camTarget

    # and the camera named 'Camera'
    cam = bpy.data.objects['Camera'].location.x = max_dim * 4.0
    
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
