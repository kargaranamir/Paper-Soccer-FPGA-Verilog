module comparator_min(
	input[7:0] a,
	input[7:0] b,
	input[7:0] c,
	input[7:0] d,
	input[7:0] e,
	input[7:0] f,
	input[7:0] g,
	input[7:0] h,
	output reg[7:0] min
);


always @(*)
begin
	if((a<=b) && (a<=c) && (a<=d) && (a<=e) && (a<=f) && (a<=g) && (a<=h))
	begin
		min = a;
	end 
	else if((b<=a) && (b<=c) && (b<=d) && (b<=e) && (b<=f) && (b<=g) && (b<=h))
	begin
		min = b;
	end
	else if((c<=a) && (c<=b) && (c<=d) && (c<=e) && (c<=f) && (c<=g) && (c<=h))
	begin
		min = c;
	end
	else if((d<=a) && (d<=b) && (d<=c) && (d<=e) && (d<=f) && (d<=g) && (d<=h))
	begin
		min = d;
	end
	else if((e<=a) && (e<=b) && (e<=c) && (e<=d) && (e<=f) && (e<=g) && (e<=h))
	begin
		min = e;
	end
	else if((f<=a) && (f<=b) && (f<=c) && (f<=d) && (f<=e) && (f<=g) && (f<=h))
	begin
		min = f;
	end
	else if((g<=a) && (g<=b) && (g<=c) && (g<=d) && (g<=e) && (g<=f) && (g<=h))
	begin
		min = g;
	end
	else if((h<=a) && (h<=b) && (h<=c) && (h<=d) && (h<=g) && (h<=f) && (h<=g))
	begin
		min = h;
	end
	else
	begin
		min = 0;
	end
	
end










endmodule