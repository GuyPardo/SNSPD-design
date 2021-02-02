% test structures in ebeam: short WSi nanowire to the ground with pad, and window in al.

% layers:
L0 = layer(0,'etch Al + WSi - LW');
L1 = layer(1, 'etch Al - LW');
L2 = layer(2, 'etch WSi - eLine');
L3 = layer(3,'Bosch - Mask');
% nanowire:
l = 3.0;
w = 0.200;
adiabatic_l = 18;
final_w = 18;
line = coplanar_line(l,w,w);
ad = adiabatic_opening(adiabatic_l, w, w, final_w, final_w*5/8).place('input', line.ports.output);
nanowire = compound_element(line,ad).set_layer(L2);

nanowire.ports.input = nanowire.elements.line.ports.input;
nanowire.ports.output = nanowire.elements.ad.ports.output;

% launcher
lau_params.line_w = 8; lau_params.line_gap = 8*5/8;
lau = launcher(lau_params).place('output', nanowire.ports.output - [10,0]).reflect([0,1]).set_layer(L0);

% window:
a = 6; b = 28; c = 35;
nodes = [-a -a;
          a -a;
          9 a
          c b;
         -c b;
         -9 a];
window = polygon_element(nodes).rotate(-pi/2).set_layer(L1);



%%
test_struct = compound_element(nanowire, lau, window).rotate(pi/2);
test_struct.elements.id_am = alignment_M(30,sprintf('%d um', l)).place('origin',test_struct.elements.nanowire.ports.input + [0,1500]).set_layer(layer(0));
arr1 = test_struct.duplicate([2,6], [34400,5000],'return_element_array',true);
arr2 = test_struct.duplicate([2,2], [11500,34000]);

%%
lens = reshape(linspace(2,24,12), [2,6]);
for i = 1:2
    for j = 1:6
        str = sprintf('%d um', lens(i,j));
        arr1.elements{i,j}.elements.id_am.elements.text.txt_str = str;
        arr1.elements{i,j}.elements.nanowire.elements.line = coplanar_line(lens(i,j),w,w).rotate(pi/2).place('output',arr1.elements{i,j}.elements.nanowire.elements.ad.ports.input ).set_layer(L2);
    end
    
end


clf
arr1.draw();
arr2.draw();


