%% full design
% written by Guy in the new library. the alignment marks (other than the id
% marks) and the wafer bound  can still be drawn with the old scripts
% the detectors and the id marks are defined here. 
array_size = [4,6];
spacing = [8000,5000];
SNSPD = SNSPD_full().place('center', [0,0]);
SNSPD_arr = duplicate(SNSPD, array_size,spacing);

% id alignmet marks
id_am = alignment_M().shift(SNSPD.ports.origin - [0,1000]).set_layer(layer(0));
id_am_arr =  duplicate(id_am, array_size,spacing);
for i=1:array_size(1)
    for j=1:array_size(2)
        txt_str = sprintf('id %d%d', array_size(1)-i+1,j);
        id_am_arr.elements{i,j}.elements.text.txt_str = txt_str;
    end
end





%% draw
SNSPD_arr.draw();
id_am_arr.draw();


