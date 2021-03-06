import Foundation
import Euclid

let voxel_vertex_offsets = [
    (0, 0, 0),
    (1, 0, 0),
    (1, 1, 0),
    (0, 1, 0),
    (0, 0, 1),
    (1, 0, 1),
    (1, 1, 1),
    (0, 1, 1),
]

let voxel_edges = [
    (0, 1),
    (1, 2),
    (2, 3),
    (3, 0),
    (4, 5),
    (5, 6),
    (6, 7),
    (7, 4),
    (0, 4),
    (1, 5),
    (2, 6),
    (3, 7),
]


//# Table driven approach to the 256 combinations. Pro-tip, don't write this by hand, copy mine!
//# See marching_cubes_gen.py for how I generated these.

//# Each value is a list of triples indicating what edges are used for that triangle
//# (Recall each edge of the cell may become a vertex in the output boundary)
let cases = [[],
             [[8, 0, 3]],
             [[1, 0, 9]],
             [[8, 1, 3], [8, 9, 1]],
             [[10, 2, 1]],
             [[8, 0, 3], [1, 10, 2]],
             [[9, 2, 0], [9, 10, 2]],
             [[3, 8, 2], [2, 8, 10], [10, 8, 9]],
             [[3, 2, 11]],
             [[0, 2, 8], [2, 11, 8]],
             [[1, 0, 9], [2, 11, 3]],
             [[2, 9, 1], [11, 9, 2], [8, 9, 11]],
             [[3, 10, 11], [3, 1, 10]],
             [[1, 10, 0], [0, 10, 8], [8, 10, 11]],
             [[0, 11, 3], [9, 11, 0], [10, 11, 9]],
             [[8, 9, 11], [11, 9, 10]],
             [[7, 4, 8]],
             [[3, 7, 0], [7, 4, 0]],
             [[7, 4, 8], [9, 1, 0]],
             [[9, 1, 4], [4, 1, 7], [7, 1, 3]],
             [[7, 4, 8], [2, 1, 10]],
             [[4, 3, 7], [4, 0, 3], [2, 1, 10]],
             [[2, 0, 10], [0, 9, 10], [7, 4, 8]],
             [[9, 10, 4], [4, 10, 3], [3, 10, 2], [4, 3, 7]],
             [[4, 8, 7], [3, 2, 11]],
             [[7, 4, 11], [11, 4, 2], [2, 4, 0]],
             [[1, 0, 9], [2, 11, 3], [8, 7, 4]],
             [[2, 11, 1], [1, 11, 9], [9, 11, 7], [9, 7, 4]],
             [[10, 11, 1], [11, 3, 1], [4, 8, 7]],
             [[4, 0, 7], [7, 0, 10], [0, 1, 10], [7, 10, 11]],
             [[7, 4, 8], [0, 11, 3], [9, 11, 0], [10, 11, 9]],
             [[4, 11, 7], [9, 11, 4], [10, 11, 9]],
             [[9, 4, 5]],
             [[9, 4, 5], [0, 3, 8]],
             [[0, 5, 1], [0, 4, 5]],
             [[4, 3, 8], [5, 3, 4], [1, 3, 5]],
             [[5, 9, 4], [10, 2, 1]],
             [[8, 0, 3], [1, 10, 2], [4, 5, 9]],
             [[10, 4, 5], [2, 4, 10], [0, 4, 2]],
             [[3, 10, 2], [8, 10, 3], [5, 10, 8], [4, 5, 8]],
             [[9, 4, 5], [11, 3, 2]],
             [[11, 0, 2], [11, 8, 0], [9, 4, 5]],
             [[5, 1, 4], [1, 0, 4], [11, 3, 2]],
             [[5, 1, 4], [4, 1, 11], [1, 2, 11], [4, 11, 8]],
             [[3, 10, 11], [3, 1, 10], [5, 9, 4]],
             [[9, 4, 5], [1, 10, 0], [0, 10, 8], [8, 10, 11]],
             [[5, 0, 4], [11, 0, 5], [11, 3, 0], [10, 11, 5]],
             [[5, 10, 4], [4, 10, 8], [8, 10, 11]],
             [[9, 7, 5], [9, 8, 7]],
             [[0, 5, 9], [3, 5, 0], [7, 5, 3]],
             [[8, 7, 0], [0, 7, 1], [1, 7, 5]],
             [[7, 5, 3], [3, 5, 1]],
             [[7, 5, 8], [5, 9, 8], [2, 1, 10]],
             [[10, 2, 1], [0, 5, 9], [3, 5, 0], [7, 5, 3]],
             [[8, 2, 0], [5, 2, 8], [10, 2, 5], [7, 5, 8]],
             [[2, 3, 10], [10, 3, 5], [5, 3, 7]],
             [[9, 7, 5], [9, 8, 7], [11, 3, 2]],
             [[0, 2, 9], [9, 2, 7], [7, 2, 11], [9, 7, 5]],
             [[3, 2, 11], [8, 7, 0], [0, 7, 1], [1, 7, 5]],
             [[11, 1, 2], [7, 1, 11], [5, 1, 7]],
             [[3, 1, 11], [11, 1, 10], [8, 7, 9], [9, 7, 5]],
             [[11, 7, 0], [7, 5, 0], [5, 9, 0], [10, 11, 0], [1, 10, 0]],
             [[0, 5, 10], [0, 7, 5], [0, 8, 7], [0, 10, 11], [0, 11, 3]],
             [[10, 11, 5], [11, 7, 5]],
             [[5, 6, 10]],
             [[8, 0, 3], [10, 5, 6]],
             [[0, 9, 1], [5, 6, 10]],
             [[8, 1, 3], [8, 9, 1], [10, 5, 6]],
             [[1, 6, 2], [1, 5, 6]],
             [[6, 2, 5], [2, 1, 5], [8, 0, 3]],
             [[5, 6, 9], [9, 6, 0], [0, 6, 2]],
             [[5, 8, 9], [2, 8, 5], [3, 8, 2], [6, 2, 5]],
             [[3, 2, 11], [10, 5, 6]],
             [[0, 2, 8], [2, 11, 8], [5, 6, 10]],
             [[3, 2, 11], [0, 9, 1], [10, 5, 6]],
             [[5, 6, 10], [2, 9, 1], [11, 9, 2], [8, 9, 11]],
             [[11, 3, 6], [6, 3, 5], [5, 3, 1]],
             [[11, 8, 6], [6, 8, 1], [1, 8, 0], [6, 1, 5]],
             [[5, 0, 9], [6, 0, 5], [3, 0, 6], [11, 3, 6]],
             [[6, 9, 5], [11, 9, 6], [8, 9, 11]],
             [[7, 4, 8], [6, 10, 5]],
             [[3, 7, 0], [7, 4, 0], [10, 5, 6]],
             [[7, 4, 8], [6, 10, 5], [9, 1, 0]],
             [[5, 6, 10], [9, 1, 4], [4, 1, 7], [7, 1, 3]],
             [[1, 6, 2], [1, 5, 6], [7, 4, 8]],
             [[6, 1, 5], [2, 1, 6], [0, 7, 4], [3, 7, 0]],
             [[4, 8, 7], [5, 6, 9], [9, 6, 0], [0, 6, 2]],
             [[2, 3, 9], [3, 7, 9], [7, 4, 9], [6, 2, 9], [5, 6, 9]],
             [[2, 11, 3], [7, 4, 8], [10, 5, 6]],
             [[6, 10, 5], [7, 4, 11], [11, 4, 2], [2, 4, 0]],
             [[1, 0, 9], [8, 7, 4], [3, 2, 11], [5, 6, 10]],
             [[1, 2, 9], [9, 2, 11], [9, 11, 4], [4, 11, 7], [5, 6, 10]],
             [[7, 4, 8], [11, 3, 6], [6, 3, 5], [5, 3, 1]],
             [[11, 0, 1], [11, 4, 0], [11, 7, 4], [11, 1, 5], [11, 5, 6]],
             [[6, 9, 5], [0, 9, 6], [11, 0, 6], [3, 0, 11], [4, 8, 7]],
             [[5, 6, 9], [9, 6, 11], [9, 11, 7], [9, 7, 4]],
             [[4, 10, 9], [4, 6, 10]],
             [[10, 4, 6], [10, 9, 4], [8, 0, 3]],
             [[1, 0, 10], [10, 0, 6], [6, 0, 4]],
             [[8, 1, 3], [6, 1, 8], [6, 10, 1], [4, 6, 8]],
             [[9, 2, 1], [4, 2, 9], [6, 2, 4]],
             [[3, 8, 0], [9, 2, 1], [4, 2, 9], [6, 2, 4]],
             [[0, 4, 2], [2, 4, 6]],
             [[8, 2, 3], [4, 2, 8], [6, 2, 4]],
             [[4, 10, 9], [4, 6, 10], [2, 11, 3]],
             [[11, 8, 2], [2, 8, 0], [6, 10, 4], [4, 10, 9]],
             [[2, 11, 3], [1, 0, 10], [10, 0, 6], [6, 0, 4]],
             [[8, 4, 1], [4, 6, 1], [6, 10, 1], [11, 8, 1], [2, 11, 1]],
             [[3, 1, 11], [11, 1, 4], [1, 9, 4], [11, 4, 6]],
             [[6, 11, 1], [11, 8, 1], [8, 0, 1], [4, 6, 1], [9, 4, 1]],
             [[3, 0, 11], [11, 0, 6], [6, 0, 4]],
             [[4, 11, 8], [4, 6, 11]],
             [[6, 8, 7], [10, 8, 6], [9, 8, 10]],
             [[3, 7, 0], [0, 7, 10], [7, 6, 10], [0, 10, 9]],
             [[1, 6, 10], [0, 6, 1], [7, 6, 0], [8, 7, 0]],
             [[10, 1, 6], [6, 1, 7], [7, 1, 3]],
             [[9, 8, 1], [1, 8, 6], [6, 8, 7], [1, 6, 2]],
             [[9, 7, 6], [9, 3, 7], [9, 0, 3], [9, 6, 2], [9, 2, 1]],
             [[7, 6, 8], [8, 6, 0], [0, 6, 2]],
             [[3, 6, 2], [3, 7, 6]],
             [[3, 2, 11], [6, 8, 7], [10, 8, 6], [9, 8, 10]],
             [[7, 9, 0], [7, 10, 9], [7, 6, 10], [7, 0, 2], [7, 2, 11]],
             [[0, 10, 1], [6, 10, 0], [8, 6, 0], [7, 6, 8], [2, 11, 3]],
             [[1, 6, 10], [7, 6, 1], [11, 7, 1], [2, 11, 1]],
             [[1, 9, 6], [9, 8, 6], [8, 7, 6], [3, 1, 6], [11, 3, 6]],
             [[9, 0, 1], [11, 7, 6]],
             [[0, 11, 3], [6, 11, 0], [7, 6, 0], [8, 7, 0]],
             [[7, 6, 11]],
             [[11, 6, 7]],
             [[3, 8, 0], [11, 6, 7]],
             [[1, 0, 9], [6, 7, 11]],
             [[1, 3, 9], [3, 8, 9], [6, 7, 11]],
             [[10, 2, 1], [6, 7, 11]],
             [[10, 2, 1], [3, 8, 0], [6, 7, 11]],
             [[9, 2, 0], [9, 10, 2], [11, 6, 7]],
             [[11, 6, 7], [3, 8, 2], [2, 8, 10], [10, 8, 9]],
             [[2, 6, 3], [6, 7, 3]],
             [[8, 6, 7], [0, 6, 8], [2, 6, 0]],
             [[7, 2, 6], [7, 3, 2], [1, 0, 9]],
             [[8, 9, 7], [7, 9, 2], [2, 9, 1], [7, 2, 6]],
             [[6, 1, 10], [7, 1, 6], [3, 1, 7]],
             [[8, 0, 7], [7, 0, 6], [6, 0, 1], [6, 1, 10]],
             [[7, 3, 6], [6, 3, 9], [3, 0, 9], [6, 9, 10]],
             [[7, 8, 6], [6, 8, 10], [10, 8, 9]],
             [[8, 11, 4], [11, 6, 4]],
             [[11, 0, 3], [6, 0, 11], [4, 0, 6]],
             [[6, 4, 11], [4, 8, 11], [1, 0, 9]],
             [[1, 3, 9], [9, 3, 6], [3, 11, 6], [9, 6, 4]],
             [[8, 11, 4], [11, 6, 4], [1, 10, 2]],
             [[1, 10, 2], [11, 0, 3], [6, 0, 11], [4, 0, 6]],
             [[2, 9, 10], [0, 9, 2], [4, 11, 6], [8, 11, 4]],
             [[3, 4, 9], [3, 6, 4], [3, 11, 6], [3, 9, 10], [3, 10, 2]],
             [[3, 2, 8], [8, 2, 4], [4, 2, 6]],
             [[2, 4, 0], [6, 4, 2]],
             [[0, 9, 1], [3, 2, 8], [8, 2, 4], [4, 2, 6]],
             [[1, 2, 9], [9, 2, 4], [4, 2, 6]],
             [[10, 3, 1], [4, 3, 10], [4, 8, 3], [6, 4, 10]],
             [[10, 0, 1], [6, 0, 10], [4, 0, 6]],
             [[3, 10, 6], [3, 9, 10], [3, 0, 9], [3, 6, 4], [3, 4, 8]],
             [[9, 10, 4], [10, 6, 4]],
             [[9, 4, 5], [7, 11, 6]],
             [[9, 4, 5], [7, 11, 6], [0, 3, 8]],
             [[0, 5, 1], [0, 4, 5], [6, 7, 11]],
             [[11, 6, 7], [4, 3, 8], [5, 3, 4], [1, 3, 5]],
             [[1, 10, 2], [9, 4, 5], [6, 7, 11]],
             [[8, 0, 3], [4, 5, 9], [10, 2, 1], [11, 6, 7]],
             [[7, 11, 6], [10, 4, 5], [2, 4, 10], [0, 4, 2]],
             [[8, 2, 3], [10, 2, 8], [4, 10, 8], [5, 10, 4], [11, 6, 7]],
             [[2, 6, 3], [6, 7, 3], [9, 4, 5]],
             [[5, 9, 4], [8, 6, 7], [0, 6, 8], [2, 6, 0]],
             [[7, 3, 6], [6, 3, 2], [4, 5, 0], [0, 5, 1]],
             [[8, 1, 2], [8, 5, 1], [8, 4, 5], [8, 2, 6], [8, 6, 7]],
             [[9, 4, 5], [6, 1, 10], [7, 1, 6], [3, 1, 7]],
             [[7, 8, 6], [6, 8, 0], [6, 0, 10], [10, 0, 1], [5, 9, 4]],
             [[3, 0, 10], [0, 4, 10], [4, 5, 10], [7, 3, 10], [6, 7, 10]],
             [[8, 6, 7], [10, 6, 8], [5, 10, 8], [4, 5, 8]],
             [[5, 9, 6], [6, 9, 11], [11, 9, 8]],
             [[11, 6, 3], [3, 6, 0], [0, 6, 5], [0, 5, 9]],
             [[8, 11, 0], [0, 11, 5], [5, 11, 6], [0, 5, 1]],
             [[6, 3, 11], [5, 3, 6], [1, 3, 5]],
             [[10, 2, 1], [5, 9, 6], [6, 9, 11], [11, 9, 8]],
             [[3, 11, 0], [0, 11, 6], [0, 6, 9], [9, 6, 5], [1, 10, 2]],
             [[0, 8, 5], [8, 11, 5], [11, 6, 5], [2, 0, 5], [10, 2, 5]],
             [[11, 6, 3], [3, 6, 5], [3, 5, 10], [3, 10, 2]],
             [[3, 9, 8], [6, 9, 3], [5, 9, 6], [2, 6, 3]],
             [[9, 6, 5], [0, 6, 9], [2, 6, 0]],
             [[6, 5, 8], [5, 1, 8], [1, 0, 8], [2, 6, 8], [3, 2, 8]],
             [[2, 6, 1], [6, 5, 1]],
             [[6, 8, 3], [6, 9, 8], [6, 5, 9], [6, 3, 1], [6, 1, 10]],
             [[1, 10, 0], [0, 10, 6], [0, 6, 5], [0, 5, 9]],
             [[3, 0, 8], [6, 5, 10]],
             [[10, 6, 5]],
             [[5, 11, 10], [5, 7, 11]],
             [[5, 11, 10], [5, 7, 11], [3, 8, 0]],
             [[11, 10, 7], [10, 5, 7], [0, 9, 1]],
             [[5, 7, 10], [10, 7, 11], [9, 1, 8], [8, 1, 3]],
             [[2, 1, 11], [11, 1, 7], [7, 1, 5]],
             [[3, 8, 0], [2, 1, 11], [11, 1, 7], [7, 1, 5]],
             [[2, 0, 11], [11, 0, 5], [5, 0, 9], [11, 5, 7]],
             [[2, 9, 5], [2, 8, 9], [2, 3, 8], [2, 5, 7], [2, 7, 11]],
             [[10, 3, 2], [5, 3, 10], [7, 3, 5]],
             [[10, 0, 2], [7, 0, 10], [8, 0, 7], [5, 7, 10]],
             [[0, 9, 1], [10, 3, 2], [5, 3, 10], [7, 3, 5]],
             [[7, 8, 2], [8, 9, 2], [9, 1, 2], [5, 7, 2], [10, 5, 2]],
             [[3, 1, 7], [7, 1, 5]],
             [[0, 7, 8], [1, 7, 0], [5, 7, 1]],
             [[9, 5, 0], [0, 5, 3], [3, 5, 7]],
             [[5, 7, 9], [7, 8, 9]],
             [[4, 10, 5], [8, 10, 4], [11, 10, 8]],
             [[3, 4, 0], [10, 4, 3], [10, 5, 4], [11, 10, 3]],
             [[1, 0, 9], [4, 10, 5], [8, 10, 4], [11, 10, 8]],
             [[4, 3, 11], [4, 1, 3], [4, 9, 1], [4, 11, 10], [4, 10, 5]],
             [[1, 5, 2], [2, 5, 8], [5, 4, 8], [2, 8, 11]],
             [[5, 4, 11], [4, 0, 11], [0, 3, 11], [1, 5, 11], [2, 1, 11]],
             [[5, 11, 2], [5, 8, 11], [5, 4, 8], [5, 2, 0], [5, 0, 9]],
             [[5, 4, 9], [2, 3, 11]],
             [[3, 4, 8], [2, 4, 3], [5, 4, 2], [10, 5, 2]],
             [[5, 4, 10], [10, 4, 2], [2, 4, 0]],
             [[2, 8, 3], [4, 8, 2], [10, 4, 2], [5, 4, 10], [0, 9, 1]],
             [[4, 10, 5], [2, 10, 4], [1, 2, 4], [9, 1, 4]],
             [[8, 3, 4], [4, 3, 5], [5, 3, 1]],
             [[1, 5, 0], [5, 4, 0]],
             [[5, 0, 9], [3, 0, 5], [8, 3, 5], [4, 8, 5]],
             [[5, 4, 9]],
             [[7, 11, 4], [4, 11, 9], [9, 11, 10]],
             [[8, 0, 3], [7, 11, 4], [4, 11, 9], [9, 11, 10]],
             [[0, 4, 1], [1, 4, 11], [4, 7, 11], [1, 11, 10]],
             [[10, 1, 4], [1, 3, 4], [3, 8, 4], [11, 10, 4], [7, 11, 4]],
             [[9, 4, 1], [1, 4, 2], [2, 4, 7], [2, 7, 11]],
             [[1, 9, 2], [2, 9, 4], [2, 4, 11], [11, 4, 7], [3, 8, 0]],
             [[11, 4, 7], [2, 4, 11], [0, 4, 2]],
             [[7, 11, 4], [4, 11, 2], [4, 2, 3], [4, 3, 8]],
             [[10, 9, 2], [2, 9, 7], [7, 9, 4], [2, 7, 3]],
             [[2, 10, 7], [10, 9, 7], [9, 4, 7], [0, 2, 7], [8, 0, 7]],
             [[10, 4, 7], [10, 0, 4], [10, 1, 0], [10, 7, 3], [10, 3, 2]],
             [[8, 4, 7], [10, 1, 2]],
             [[4, 1, 9], [7, 1, 4], [3, 1, 7]],
             [[8, 0, 7], [7, 0, 1], [7, 1, 9], [7, 9, 4]],
             [[0, 7, 3], [0, 4, 7]],
             [[8, 4, 7]],
             [[9, 8, 10], [10, 8, 11]],
             [[3, 11, 0], [0, 11, 9], [9, 11, 10]],
             [[0, 10, 1], [8, 10, 0], [11, 10, 8]],
             [[11, 10, 3], [10, 1, 3]],
             [[1, 9, 2], [2, 9, 11], [11, 9, 8]],
             [[9, 2, 1], [11, 2, 9], [3, 11, 9], [0, 3, 9]],
             [[8, 2, 0], [8, 11, 2]],
             [[11, 2, 3]],
             [[2, 8, 3], [10, 8, 2], [9, 8, 10]],
             [[0, 2, 9], [2, 10, 9]],
             [[3, 2, 8], [8, 2, 10], [8, 10, 1], [8, 1, 0]],
             [[1, 2, 10]],
             [[3, 1, 8], [1, 9, 8]],
             [[9, 0, 1]],
             [[3, 0, 8]],
             []]

public func marching_cubes(data: IsoSurfaceDataSource,
                           xRange: ClosedRange<Double> = -3...3,
                           yRange: ClosedRange<Double> = -3...3,
                           zRange: ClosedRange<Double> = -3...3,
                           resolution: Double = 1,
                           threshold: Double = 1.0,
                           material: Polygon.Material, adaptive: Bool = false) -> Mesh {
    var combined_mesh = Mesh([])
    for x in stride(from: xRange.lowerBound, through: xRange.upperBound, by: resolution) {
        for y in stride(from: yRange.lowerBound, through: yRange.upperBound, by: resolution) {
            for z in stride(from: zRange.lowerBound, through: zRange.upperBound, by: resolution) {
                let cell_mesh = marching_cubes_single_cell(data: data, x: x, y: y, z: z, material: material, threshold: threshold, adaptive: adaptive)
//                print("cell at \(x),\(y),\(z) : \(cell_mesh.summary)")
                combined_mesh = combined_mesh.merge(cell_mesh)
            }
        }
    }
    return combined_mesh
}

/// Generates the data for a 3D mesh representation for a single voxel.
/// - Parameters:
///   - data: The data source that provides the density value at a given 3D location.
///   - x: The x coordinate of the voxel to render.
///   - y: The y coordinate of the voxel to render.
///   - z: The z coordinate of the voxel to render.
///   - material: The material to use when rendering the polygon
///   - threshold: The value that determines if a point in the field is inside, or outside, the surface.
///   - adaptive: If true, uses linear interpolation to determine vertex locations closer to the threshold level; otherwise, is chooses a point between the two edges of the voxel cube.
///   - homeworkMode: If true, enables detailed print statements showing the calculations and logic for the choice of locations for the polygon(s).
/// - Returns: A mesh made up of the polygons for this voxel cell
func marching_cubes_single_cell(data: IsoSurfaceDataSource, x: Double, y: Double, z: Double, material: Polygon.Material, threshold: Double = 1.0, adaptive: Bool = false, homeworkMode: Bool = false) -> Mesh {
    
    // iterate through the corners of the voxel, and get the data value from each of those locations.
    let valuesAtCorners = voxel_vertex_offsets.map { (x_offset: Int, y_offset: Int, z_offset: Int) in
        data.isovalue(x: x + Double(x_offset),
                      y: y + Double(y_offset),
                      z: z + Double(z_offset))
    }
    if homeworkMode {
        // values at the corners of the voxel
        print(valuesAtCorners)
        // threshold evaluation at the corners of the voxel cube
        print(valuesAtCorners.map({ val in
            return check(val > threshold)
        }))
    }
    
    // If the value at each corner is greater than the threshold value, then its considered inside
    // the surface we're creating.
    // Build an index to our lookup table of the face combinations that we'll use to represent this voxel.
    // Each corner is assigned a value to the power of 2, and a combined index is built from the corners
    // that match to being "inside" the surface.
    var cubeindex: Int = 0;
    if (valuesAtCorners[0] > threshold) { cubeindex |= 1 }
    if (valuesAtCorners[1] > threshold) { cubeindex |= 2 }
    if (valuesAtCorners[2] > threshold) { cubeindex |= 4 }
    if (valuesAtCorners[3] > threshold) { cubeindex |= 8 }
    if (valuesAtCorners[4] > threshold) { cubeindex |= 16 }
    if (valuesAtCorners[5] > threshold) { cubeindex |= 32 }
    if (valuesAtCorners[6] > threshold) { cubeindex |= 64 }
    if (valuesAtCorners[7] > threshold) { cubeindex |= 128 }
    
    let faces = cases[cubeindex]
    if homeworkMode {
        print("faces: \(faces)")
    }
    var output_tris: [Polygon] = []
    for face in faces {
        // For each face, find the vertices of that face and output it.
        // There's no effort in this algorithm to re-use vertices between the faces.
        let edges = face // ex: [10, 6, 5]
        let verts = edges.map { edgeIndex in
            return edge_to_boundary_vertex(edge: edgeIndex, cornerValues: valuesAtCorners, x: x, y: y, z: z, threshold: threshold, adaptive: adaptive, homeworkMode: homeworkMode)
        }
        //        print("verts identified by this face: \(verts.map({ $0.summary }))")
        if let poly = Polygon(verts, material: material) {
            if homeworkMode {
                print("polygon \(poly.summary)")
            }
            output_tris.append(poly)
        }
    }
    return Mesh(output_tris)
}

/// Returns a vertex in the middle of the specified edge of a voxel cube.
/// - Parameter edge: The index of the edge of the voxel.
/// - Parameter cornerValues: An array of the evaluated values at each of the corners of the voxel cube.
/// - Parameter x: The x coordinate location of the voxel being evaluated.
/// - Parameter y: The y coordinate location of the voxel being evaluated.
/// - Parameter z: The z coordinate location of the voxel being evaluated.
/// - Parameter threshold: The thresold value of the isofield that's being matched
/// - Parameter adaptive: If true, chooses a vertex location based on interpolation of the isofield values on the relevant edges.
/// - Parameter homeworkMode: If true, enables detailed print statements showing the calculations and logic for the choice of locations for the polygon(s).
/// - Returns: a vector location interpolated between the corners for the face of the polygon
public func edge_to_boundary_vertex(edge: Int, cornerValues: [Double], x: Double, y: Double, z: Double, threshold: Double, adaptive: Bool = false, homeworkMode: Bool = false) -> Vector {
    // Find the two vertices specified by this edge, and interpolate
    // between them to determine a vertex location.
    let v0 = voxel_edges[edge].0
    let v1 = voxel_edges[edge].1
    // ex. edge 10 matches to (2, 6) - so v0 -> corner 2, v1 -> corner 6.
    // v0 and v1 are identifying the corner indexes of the edge
    // that we're trying to interpolate.
    
    // If 'adaptive' is true, interpolate a vertex position on the edge provided that most closely matches the isovalue's threshold.
    // Otherwise, we pick a quick-n-dirty point that's exactly halfway between the vertex positions.
    // In either case, t0 and t1 are the unit-measure offsets for the vertex positions.
    let t0: Double
    if adaptive {
        if homeworkMode {
            print("Adaptive mode enabled: calculating interpolation")
        }
        // Get the values of the field at each of the two corner
        // locations.
        let f0 = cornerValues[v0] - threshold
        let f1 = cornerValues[v1] - threshold
        // With subtracting the threshold value that was
        // applied to determine the edge case, these two values
        // are expected to be on opposite sides of '0' - one positive,
        // one negative.
        let verifiedOppositeSigns = (f0 > 0) != (f1 > 0)
        precondition(verifiedOppositeSigns, "The isovalues being interpolated (\(f0), and \(f1) aren't opposite signs. The original values from the field are \(cornerValues[v0]) and \(cornerValues[v1]), and the threshold value \(threshold).")        
        t0 = normalizedOffset(f0, f1)
        if homeworkMode {
            print("first corner index #\(v0), second corner index #\(v1).")
            print("The isofield values at the corners are \(f0) and \(f1)")
            print("Calculate the unit-offset (t0) from corner #\(v0) to #\(v1):")
            print("calc: ( 0 - \(f0) ) / ( \(f1) - \(f0) )")
            print("   -> \(0 - f0) / \(f1 - f0)")
            print("   -> \(t0)")
        }
    } else {
        if homeworkMode {
            print("Non-adaptive mode enabled: choosing half-way point")
        }
        t0 = 0.5
    }
    
    // Using the unit-offset between the two corners, we choose
    // the location of the vertex between those two corners.
    let vert0_offsets = voxel_vertex_offsets[v0] // tuple of the corner - ex: corner 2 -> (1,1,0)
    let vert1_offsets = voxel_vertex_offsets[v1]
    if homeworkMode {
        print("The calculated position reference is \(x), \(y), \(z)")
        print("The offsets for the first corner are \(vert0_offsets)")
        print("The offsets for the second corner are \(vert1_offsets)")
    }
    let finalX = x + Double(vert0_offsets.0) + t0 * Double(vert1_offsets.0 - vert0_offsets.0)
        if homeworkMode {
            print("The X coordinate to interpolate between: \(x + Double(vert0_offsets.0)) (corner #\(v0)) to \(x + Double(vert1_offsets.0)) (corner #\(v1)).")
            print("calc: \(x) + \(Double(vert0_offsets.0)) + \(t0) * (\(vert1_offsets.0)-\(vert0_offsets.0)")
            print(" ->   \(x) + \(Double(vert0_offsets.0)) +  \(t0) * \(Double(vert1_offsets.0 - vert0_offsets.0))")
            print(" ->   \(x) + \(Double(vert0_offsets.0)) +  \(t0 * Double(vert1_offsets.0 - vert0_offsets.0))")
            print("The chosen X position: \(finalX)")
        }

    let finalY = y + Double(vert0_offsets.1) + t0 * Double(vert1_offsets.1 - vert0_offsets.1)
        if homeworkMode {
            print("The Y coordinate to interpolate between: \(y + Double(vert0_offsets.1)) (corner #\(v0)) to \(y + Double(vert1_offsets.1)) (corner #\(v1)).")
            print("calc: \(y) + \(Double(vert0_offsets.1)) + \(t0) * (\(vert1_offsets.1)-\(vert0_offsets.1)")
            print(" ->   \(y) + \(Double(vert0_offsets.1)) + \(t0) * \(Double(vert1_offsets.1 - vert0_offsets.1))")
            print(" ->   \(y) + \(Double(vert0_offsets.1)) + \(t0 * Double(vert1_offsets.1 - vert0_offsets.1))")
            print("The chosen Y position: \(finalY)")
        }
    
    let finalZ = z + Double(vert0_offsets.2) + t0 * Double(vert1_offsets.2 - vert0_offsets.2)
        if homeworkMode {
            print("The Z coordinate to interpolate between: \(z + Double(vert0_offsets.2)) (corner #\(v0)) to \(z + Double(vert1_offsets.2)) (corner #\(v1)).")
            print("calc: \(z) + \(Double(vert0_offsets.2)) + \(t0) * (\(vert1_offsets.2)-\(vert0_offsets.2)")
            print(" ->   \(z) + \(Double(vert0_offsets.2)) + \(t0) * \(Double(vert1_offsets.2 - vert0_offsets.2))")
            print(" ->   \(z) + \(Double(vert0_offsets.2)) + \(t0 * Double(vert1_offsets.2 - vert0_offsets.2))")
            print("The chosen Z position: \(finalZ)")
        }
                
    return Vector(finalX, finalY, finalZ)
}
