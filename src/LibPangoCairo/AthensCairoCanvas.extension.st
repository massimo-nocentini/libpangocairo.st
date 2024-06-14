Extension { #name : 'AthensCairoCanvas' }

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> gdkCairoSetSourcePixbuf: pixbufHandle x: x y: y [
	"For the sake of clarity, we report [an example](https://gist.github.com/bert/985903/1f7675464104c70fb65ed93328b7538f459775dc).

```language=c
#include <glib.h>
#include <cairo.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

int main (void)
{
        GdkPixbuf *pixbuf;
        gint width;
        gint height;
        cairo_format_t format;
        cairo_surface_t *surface;
        cairo_t *cr;

        g_type_init ();
        pixbuf = gdk_pixbuf_new_from_file (""test.png"", NULL);
        g_assert (pixbuf != NULL);
        format = (gdk_pixbuf_get_has_alpha (pixbuf)) ? CAIRO_FORMAT_ARGB32 : CAIRO_FORMAT_RGB24;
        width = gdk_pixbuf_get_width (pixbuf);
        height = gdk_pixbuf_get_height (pixbuf);
        surface = cairo_image_surface_create (format, width, height);
        g_assert (surface != NULL);
        cr = cairo_create (surface);
        /* Draw the pixbuf */
        gdk_cairo_set_source_pixbuf (cr, pixbuf, 0, 0);
        cairo_paint (cr);
        /* Draw a red rectangle */
        cairo_set_source_rgb (cr, 1, 0, 0);
        cairo_rectangle (cr, width * .25, height * .25, width *.5, height *.5);
        cairo_fill (cr);
        /* Save to a PNG file */
        cairo_surface_write_to_png (surface, ""output.png"");
        cairo_surface_destroy (surface);
        cairo_destroy (cr);
        return 0;
}
```
"

	<primitive: 'primitive_gdk_cairo_set_source_pixbuf' module:
	'CairoGraphicsPlugin'>
	self primitiveFailed
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> showLayout: layout [

	self
		ffiCall: #( void pango_cairo_show_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> updateContext: context [

	self
		ffiCall:
		#( void pango_cairo_update_context #( self , void * context ) )
		module: PangoCairoLibrary
]

{ #category : '*LibPangoCairo' }
AthensCairoCanvas >> updateLayout: layout [

	self
		ffiCall:
		#( void pango_cairo_update_layout #( self , void * layout ) )
		module: PangoCairoLibrary
]
