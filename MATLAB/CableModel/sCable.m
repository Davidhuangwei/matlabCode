function NeuronParams=sCable
% 40 compartment 1 simple cabel
b= @(x)(((x^(3/2)+x^(3/2))^(2/3)));
%%
initmat=[...% Name	Parent	Length	Theta(x-y)	Phi(z)	Diam.
    0	0	0	0	0	17.5;
1	0	16	0	180	3.5;
2	1	17	0	180	3.27;
3	2	18	0	180	3.07;
4	3	16	0	180	2.91;
5	4	15	0	180	2.77;
6	5	17	0	180	2.65;
7	6	16	0	180	2.55;
8	7	15	0	180	2.47;
9	8	16	0	180	2.4;
10	9	16	0	180	2.33;
11	10	15	0	180	2.28;
12	11	13	0	180	2.24;
13	12	13	0	180	2.2;
14	13	14	0	180	2.17;
15	14	12	0	180	2.15;
16	15	12	0	180	2.12;
17	16	14	0	180	2.1;
18	17	13	0	180	2.08;
19	18	13	0	180	2.06;
20	19	14	0	180	2.04;
21	20	15	0	180	2.02;
22	21	14	0	180	2.01;
23	22	13	0	180	2;
24	23	13	0	180	2;
25	24	12	0	180	b(b(.75));% (3/2) rule neurons.
26	25	13	0	180	b(b(.75));% (3/2
27	26	14	0	180	b(b(.75));% (3/2) rule neurons.
28	27	15	0	180	b(b(.75));% (3/2
29	28	15	0	180	b(b(.75));%b() double combine...
30	29	15	0	180	b(b(.75));% b()
31	30	15	0	180	b(b(.75));%b() 
32	31	15	0	180	b(b(.75));% b()
33	32	15	0	180	b(b(.75));% b(b())
34	33	15	0	180	b(b(.75));% (b())

35	0	20	0	0	b(b(0.75));
36	35	20	0	0	b(b(0.75));
37	36	24	0	0	b(b(0.75));
38	37	26	0	0	b(b(b(0.75)));
39	38	30	0	0	b(b(b(0.75)));
% 40	39	30	0	180	b(b(0.75));
];% 
%%
NeuronParams.compartmentDiameterArr =initmat(:,end);
NeuronParams.numCompartments=size(initmat,1);
compStruc=zeros(5,NeuronParams.numCompartments);
% 1. dendry layer
% 2. parents
% 3. length
% 4. theta (to Z ->0 )
% 5. phi x-y plane
compStruc(2:end,:)=initmat(:,[2 3 5 4])';
compStruc(2,:)=compStruc(2,:)+1;
NeuronParams.compartmentLength=compStruc(3,:)';
NeuronParams.compartmentParentArr = compStruc(2,:)';
NeuronParams.compartmentXPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentYPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentZPositionMat = zeros(NeuronParams.numCompartments,2);
NeuronParams.compartmentZPositionMat(1,:)=[-17.5 17.5]/2;
for k=2:NeuronParams.numCompartments
    pp=compStruc(2,k);
    if pp
        bgp=[NeuronParams.compartmentXPositionMat(pp,2),NeuronParams.compartmentYPositionMat(pp,2),NeuronParams.compartmentZPositionMat(pp,2)];
    else
        if k<35
        bgp=[0 0 -17.5]/2;
        else
            bgp=[0 0 17.5]/2;
        end
    end
    NeuronParams.compartmentXPositionMat(k,:)=bgp(1)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*cos(pi/180*compStruc(5,k))];
    NeuronParams.compartmentYPositionMat(k,:)=bgp(2)+...
        [0, compStruc(3,k)*sin(pi/180*compStruc(4,k))*sin(pi/180*compStruc(5,k))];
    NeuronParams.compartmentZPositionMat(k,:)=bgp(3)+...
        [0, compStruc(3,k)*cos(pi/180*compStruc(4,k))];
end
NeuronParams.ds=abs(NeuronParams.compartmentZPositionMat(:,1));
NeuronParams.compartmentLength(1)=NeuronParams.compartmentDiameterArr(1);