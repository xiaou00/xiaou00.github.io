#let colim = $limits(op("colim"))$
#let Spec = $op("Spec")$
#let Specm = $op("Specm")$
#let Frac = $op("Frac")$
#let Coeq = $op("coeq")$
#let res = $op("res")$
#let char = $"char"$
#let Eq = $op("Eq")$
#let Deck = "Deck"
#let tr = "tr"
#let rk = "rk"
#let pfin = $pi"fin"$
#let sep = "sep"
#let pro = "pro"
#let Hoch = "HH"
#let Ho = "H"
#let Res = "Res" 
#let Gal = "Gal"
#let rad = "rad"
#let Ann = "Ann"
#let Lift = "Lift"
#let Shape = "Shape"
#let Amp = "Amp"
#let dR = "dR"
#let FH = $"F"_"H"$
#let FHKR = $"F"_"HKR"$
#let gr = "gr"
#let Frob = "Frob"
#let act = $arrow.half.cw$
#let cn = "cn"
#let coev = "coev"
#let wedge = $or$
#let smash = $and$
#let cop = $union.sq$
#let cup = $union$
#let cap = $inter$
#let tens = $times.o$
#let dtens = $times.o^bold("L")$
#let RHom = $bold("R")"Hom"$
#let dtimes = $times^bold("R")$
#let semidirect = $\u{22ca}$
#let pairarrow = $\u{21c9}$
#let larr = $stretch(->)$
#let smile = $op(smile)$
#let veq = $#rotate(90deg, $=$)$
#let vdeq = $#rotate(90deg, $=:$)$


#let GL = $"GL"$
#let SL = $"SL"$

#let et = "ét"
#let DK = "DK"
#let Ner = $"N"_bullet$
#let fib = $"fib"$
#let cofib = $"cofib"$
#let coker = $"coker"$
#let dg = $"dg"$
#let trunl(args) = $tau_(<= args)$
#let trunr(args) = $tau_(>= args)$

#let Hom = "Hom"
#let Nat = "Nat"
#let Mater = "Mat"
#let SqExt = $"SqExt"$
#let Map = "Map"
#let Cov = "Cov"
#let Mul = "Mul"
#let Der = "Der"
#let Aut = "Aut"
#let End = "End"
#let Lan = "Lan"
#let Ran = "Ran"
#let Pic = "Pic"
#let Ext = "Ext"
#let Tor = "Tor"
#let Bar = "Bar"
#let Nm = "Nm"
#let Sym = "Sym"
#let LSym = "LSym"
#let LGamma = $"L"Gamma$
#let LLambda = $"L"Lambda$
#let Gr = "Gr"
#let Wh = "Wh"
#let Hilb = "Hilb"
#let Quot = "Quot"
#let Assem = "Assem"
#let opp = "op"
#let pr = "pr"
#let ev = "ev"
#let Spf = "Spf"
#let CH = "CH"
#let SqZ = $"SqZ"$
#let yo = context if target() == "html" {
  html.elem("mrow", attrs: (style: "font-style: normal; font-size: 0.9em"), [よ])
} else {
  text(size: 0.9em, style: "normal")[よ]
}

#let gl = $frak("gl")$
#let sl = $frak("sl")$

#let Fun = $sans("Fun")$
#let BiFun = $sans("BiFun")$
#let Exc = $sans("Exc")$
#let Act = $sans("Act")$
#let Env = $sans("Env")$
#let Set = $sans("Set")$
#let Open = $sans("Open")$
#let PShv = $sans("PShv")$
#let Shv = $sans("Shv")$
#let LRep = $sans("LRep")$
#let Ab = $sans("Ab")$
#let Ring = $sans("Ring")$
#let CRing = $sans("CRing")$
#let Mod = $sans("Mod")$
#let QCoh = $sans("QCoh")$
#let Grp = $sans("Grp")$
#let Sch = $sans("Sch")$
#let Top = $sans("Top")$
#let LRS = $sans("LRS")$
#let Aff = $sans("Aff")$
#let Cat = $sans("Cat")$
#let Grpd = $sans("Grpd")$
#let Ani = $sans("Ani")$
#let St = $sans("St")$
#let PSt = $sans("PSt")$
#let sSet = $sans("sSet")$
#let CG = $sans("CG")$
#let QCat = $sans("QCat")$
#let Sp = $sans("Sp")$
#let Ch = $sans("Ch")$
#let dgCat = $sans("dgCat")$
#let Kcat = $sans("K")$
#let Dcat = $sans("D")$
#let Fin = $sans("Fin")$
#let Op = $sans("Op")$
#let POp = $sans("POp")$
#let Comm = $sans("Comm")$
#let Assoc = $sans("Assoc")$
#let Alg = $sans("Alg")$
#let CAlg = $sans("CAlg")$
#let Mon = $sans("Mon")$
#let CMon = $sans("CMon")$
#let AlgSp = $sans("AlgSp")$
#let DMSt = $sans("DMSt")$
#let ArtSt = $sans("ArtSt")$
#let LieAlg = $sans("LieAlg")$
#let Vect = $sans("Vect")$
#let Rep = $sans("Rep")$
#let Lie = $sans("Lie")$
#let Perf = $sans("Perf")$
#let LMod = $sans("LMod")$
#let dga = $sans("dgAlg")$
#let Ind = $sans("Ind")$
#let Pro = $sans("Pro")$
#let sInd = $sans("sInd")$
#let cdga = $sans("cdgAlg")$
#let scdga = $sans("scdgAlg")$
#let aRing = $sans("aRing")$
#let AniAlg = $sans("AniAlg")$
#let aCAlg = $sans("aCAlg")$
#let aMod = $sans("aMod")$
#let AugAlg = $sans("AugAlg")$
#let Poly = $sans("Poly")$
#let Pr = $sans("Pr")$
#let PrR = $sans("Pr")^"R"$
#let PrL = $sans("Pr")^"L"$
#let Cell = $sans("Cell")$
#let Idem = $sans("Idem")$
#let dCAlg = $sans("dCAlg")$
#let dRing = $sans("dRing")$
#let dMod = $sans("dMod")$
#let dSch = $sans("dSch")$
#let Mnd = $sans("Mnd")$
#let Mfd = $sans("Mfd")$
#let DF = $sans("DF")$
#let Euc = $sans("Euc")$ 
#let Desc = $sans("Desc")$
#let Topos = $sans("Topos")$
#let Gerb = $sans("Gerb")$
#let EM = $sans("EM")$
#let dAff = $sans("dAff")$
#let dPSt = $sans("dPSt")$
#let dSt = $sans("dSt")$
#let Word = $sans("Word")$
#let Mat = $sans("Mat")$
#let Et = $sans("Et")$
#let dEt = $sans("dEt")$
#let FEt = $sans("FEt")$
#let dFEt = $sans("dFEt")$
#let CooRing = $bold(sans("C"^oo"Ring"))$
#let CooAlg = $bold(sans("C"^oo"Alg"))$
#let ProFin = $sans("ProFin")$
#let ProAni = $sans("ProAni")$
#let FGrp = $sans("FGrp")$
#let PFGrp = $sans("PFGrp")$
#let PFAni = $sans("PFAni")$
#let PFAb = $sans("PFAb")$
#let FCov = $sans("FCov")$
#let Cov = $sans("Cov")$
#let LocSys = $sans("LocSys")$
#let Corr = $sans("Corr")$
#let FF3 = $sans("3FF")$
#let FF6 = $sans("6FF")$

#let ideal = $op(lt.closed)$
#let ad = $"ad"$
#let simeq = $tilde.eq$
#let brac = (
  l:$bracket.l.stroked$,
  r:$bracket.r.stroked$
)

#let simp(str) = $sans("s")str$
#let cat(name) = $bold(sans(name))$

#let rightarrow = $stretch(->, size: #15pt)$
#let movebase(size, x) = text(baseline: size)[#x]
#let injlim = $display(limits(lim_(movebase(#(-1.9pt),rightarrow))))$
#let varinjlim(subscript) = $injlim_movebase(#(-2.8pt), subscript)$

#let leftarrow = $stretch(<-, size: #15pt)$
#let projlim = $display(limits(lim_(movebase(#(-1.9pt),leftarrow))))$
#let varprojlim(subscript) = $projlim_movebase(#(-2.8pt), subscript)$

#let quot(content) = $op(#h(0pt)''content#h(0pt)'')$

