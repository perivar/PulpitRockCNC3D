import bpy
import sys

global selObj
global camTargetPos
#mat = 'abs' # The material to use on the imported STL is called "abs"  
            # e.g. orange plastic with white gloss 
            # this is saved with as "F abs" so that it is saved with the 
	    # blend file even if the material isn't used

mat = 'plastic'
			
# load stl file			
def load_stl(file_path):
    global camTargetPos,selObj
    
    # load stl
    bpy.ops.import_mesh.stl(filepath=file_path)
    
    # select properly
    selObj = bpy.context.selected_objects[0]
    print('Selected object: ', selObj)
    bpy.ops.object.select_all(action='DESELECT')
    selObj.select = True
    	
    # set origin
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='BOUNDS')
    
    # place
    # d = selObj.dimensions
    # x = d[0]
    # y = d[1]
    # z = d[2]
    zDim = selObj.dimensions[2]
    print('Z dimension: ', zDim)
	
    # resize to much smaller
    bpy.ops.transform.resize(value=(0.001, 0.001, 0.001))
	
    # Translate (move) selected items half it's height upwards
    #bpy.ops.transform.translate(value=(0,0,zDim/2.0))
    # Note this throws an error 'convertviewvec called in invalid context'

    # calculate camera target in the z axis
    camTargetPos = (0,0,zDim/3.0)
    print('Camera target: ', camTargetPos)
	
    # assign material
    selObj.material_slots.data.active_material = bpy.data.materials[mat]

def place_camera():
    global camTargetPos
	
    # place the camera, first get the object dimensions
    d = selObj.dimensions
    x = d[0]
    y = d[1]
    z = d[2]
	
    # scale z and y down with 25%
    max_dim = max(x * 0.75, y * 0.75, z)
    print('Max dimensions: ', max_dim)
	
    # place camera at the target calculated in the load_stl method
    # this require a special 'empty - target - sphere' element
    bpy.data.objects['target'].location = camTargetPos
    cam = bpy.data.objects['Camera'].location.x = max_dim * 2.4

def render_image(image):
    # render image
    bpy.ops.render.render(write_still=True)
    bpy.data.images['Render Result'].save_render(filepath=image)

	
# read the parameters from the command line			
image = sys.argv[-1]
stl = sys.argv[-2]
print('stl: ', stl)
print('image: ', image)

# run the methods
load_stl(stl)
#place_camera()
render_image(image)
