import bpy
import sys

# The material to use on the imported STL
# this is saved with as "F Steel" so that it is saved with the 
# blend file even if the material isn't used
mat = 'Steel'
			
# load stl file			
def load_stl(file_path):
    # load stl
    bpy.ops.import_mesh.stl(filepath=file_path)
    
    # select properly
    selObj = bpy.context.selected_objects[0]
    print('Selected object: ', selObj)
    bpy.ops.object.select_all(action='DESELECT')
    selObj.select = True
    	
    # set origin (GEOMETRY_ORIGIN Geometry to Origin, Move object geometry to object origin.)
    bpy.ops.object.origin_set(type='GEOMETRY_ORIGIN', center='BOUNDS')

    # resize 
    # the imported STL from OpenSCad has dimensions in mm	
    # pulley:           Orig dimensions:  <Vector (16.0000, 16.0000, 16.2000)>
    # MotorAndCoupling: Orig dimensions:  <Vector (42.3000, 42.3000, 83.0000)>
    # Coupling:         Orig dimensions:  <Vector (19.0000, 19.0000, 25.0000)>
    #resizeFactor = 0.005 	# motor and coupling
    #resizeFactor = 0.013 	# coupling
    #resizeFactor = 0.022 	# pulley
    viewHeight = 0.4
    resizeFactor = viewHeight / selObj.dimensions[2]
    bpy.ops.transform.resize(value=(resizeFactor, resizeFactor, resizeFactor))

    # d = selObj.dimensions
    # x = d[0]
    # y = d[1]
    # z = d[2]
    zDim = selObj.dimensions[2]
    print('Z dimension: ', zDim)
		
    # translate (move) selected items half it's height upwards
    bpy.ops.transform.translate(value=(0,0,zDim/2.0))

    # UV unwrap
    bpy.ops.object.editmode_toggle()
    bpy.ops.mesh.tris_convert_to_quads() # straigthens up when using a texture
    bpy.ops.uv.smart_project()
    bpy.ops.object.editmode_toggle()
	
    # assign material
    selObj.material_slots.data.active_material = bpy.data.materials[mat]


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
render_image(image)
