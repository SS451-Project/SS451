/obj/vehicle/snowmobile
	name = "Красный снегоход"
	desc = "Уииииииииии!"
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "snowmobile"
	move_speed = 0
	key_type = /obj/item/key/snowmobile
	generic_pixel_x = 0
	generic_pixel_y = 4

/obj/vehicle/snowmobile/blue
	name = "Синий снегоход"
	icon_state = "bluesnowmobile"

/obj/vehicle/snowmobile/key/New()
	inserted_key = new /obj/item/key/snowmobile(null)

/obj/vehicle/snowmobile/blue/key/New()
	inserted_key = new /obj/item/key/snowmobile(null)
/obj/item/key/snowmobile
	name = "Ключ от снегохода"
	desc = "Брелок с маленьким стальным ключом и биркой с красным крестом на ней; очевидно, это не означает, что вы собираетесь за этим в больницу..."
	icon_state = "keydoc" //get a better icon, sometime.
