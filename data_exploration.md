# I like to get a "feel" for the data in a database when working on a new project.
# I find that this enables a better intuitive reasoning about the data and the relations
# Here is how I explored the data before starting to work on the project. Pretty basic but helps a lot.


    Item.id

    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320]

    Item.size

    pp Item.select('Size, count(*) as count').group('Color').map{|i| [i.color, i.count]};nil

    ["L", 120], 
    ["M", 120], 
    ["S", 60]],
    [["ANY", 20] 


    # Item.color
	
    2.1.1 :039 > pp Item.select('color, count(*) as count').group('Color').map{|i| [i.color, i.count]}.sort{|x,y| y[1] <=> x[1]};nil
      Item Load (0.5ms)  SELECT color, count(*) as count FROM "items"  GROUP BY Color
      
    [["Orange", 50],
     ["Blue", 50],
     ["Green", 50],
     ["Navy", 50],
     ["Black", 25],
     ["Purple", 25],
     ["Red", 25],
     ["White", 25],
     ["Turquoise", 20]]
    
    
    # Item.status
	
    pp Item.select('status, count(*) as count').group('Status').map{|i| [i.status, i.count]}.sort{|x,y| y[1] <=> x[1]};nil
      Item Load (0.5ms)  SELECT status, count(*) as count FROM "items"  GROUP BY Status
      
    [["sellable", 301], ["clearanced", 19]]
    

    Style.name
    
    [[1, "Abrianna Lightweight Knit Cardigan"],
     [2, "Bryan Short-Sleeve Open-Front Cardigan"],
     [3, "Vicky Colorblock Trim Silk Blouse"],
     [4, "Collegno Diamond Print Drawstring Waist Dress"],
     [5, "Pomelo Critter Print Maxi Dress"],
     [6, "Leah Straight Leg Cuffed Jean"],
     [7, "Henry Birds on Branch Infinity Scarf"],
     [8, "Blue Camo Print Boyfriend Jeans"]]
     

    # Style.type
    pp Style.select('type, count(*) as count').group('type').map{|i| [i.type, i.count]}.sort{|x,y| y[1] <=> x[1]};nil

    [["Dress", 4],
    ["Pants", 4],
    ["Sweater", 4],
    ["Scarf", 2],
    ["Top", 2]]