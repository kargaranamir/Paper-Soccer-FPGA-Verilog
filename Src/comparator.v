module comparator(
	input[7:0] a,
	input[7:0] b,
	input[7:0] c,
	input[7:0] d,
	input[7:0] e,
	input[7:0] f,
	input[7:0] g,
	input[7:0] h,
	output reg [7:0] max
);


always @(*)
begin
	if((b<=a) && (c<=a) && (d<=a) && (e<=a) && (f<=a) && (g<=a) && (h<=a))
	begin
		max = a;
	end 
	else if((a<=b) && (c<=b) && (d<=b) && (e<=b) && (f<=b) && (g<=b) && (h<=b))
	begin
		max = b;
	end
	else if((a<=c) && (b<=c) && (d<=c) && (e<=c) && (f<=c) && (g<=c) && (h<=c))
	begin
		max = c;
	end
	else if((a<=d) && (b<=d) && (c<=d) && (e<=d) && (f<=d) && (g<=d) && (h<=d))
	begin
		max = d;
	end
	else if((a<=e) && (b<=e) && (c<=e) && (d<=e) && (f<=e) && (g<=e) && (h<=e))
	begin
		max = e;
	end
	else if((a<=f) && (b<=f) && (c<=f) && (d<=f) && (e<=f) && (g<=f) && (h<=f))
	begin
		max = f;
	end
	else if((a<=g) && (b<=g) && (c<=g) && (d<=g) && (e<=g) && (f<=g) && (h<=g))
	begin
		max = g;
	end
	else if((a<=h) && (b<=h) && (c<=h) && (d<=h) && (e<=h) && (f<=h) && (g<=h))
	begin
		max = h;
	end
	else
	begin
		max = 0;
	end
	
end










endmodule