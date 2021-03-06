%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                  %%
%%    KLASSEN FSTILDOK                                              %%
%%    BASSERAD PÅ PAKETET FSTIL                                     %%
%%                                                                  %%
%%    PAKETET FSTIL                                                 %%
%%    Skrivet av Tomas Lycken, F-08, under 2011                     %%
%%    Senast uppdaterat av Tomas Lycken, F-08, 2011                 %%
%%    Senast uppdaterat av Emil Ringh, F-08, 2011                   %%
%%    Senast uppdaterat av Emil Ringh, F-08, 2012                   %%
%%    Senast uppdaterat av Emil Ringh, F-08, 2013                   %%
%%    Senast uppdaterat av Tomas Lycken, F-08, 2013                 %%
%%    Senast uppdaterat av Emil Ringh, F-08, 2014                   %%
%%    Senast uppdaterat av Mårten Vuorinen, F-12, 2016              %%
%%    Senast uppdaterat av Johan Engvall, F-07, 2017                %%
%%    Senast uppdaterat av Anton Lu, F-15, 2017                     %%
%%    Senast uppdaterad av Gustav Gybäck, F-15, 2018                %%
%%                                                                  %%
%%    KLASSEN FSTILDOK                                              %%
%%    Skriven av Emil Ringh F-08 och Gustav Gybäck, F-15 2018       %%
%%                                                                  %%
%%    Klassen fstildok importerar några paket och gör ett antal nya %%
%%    kommandon tillgängliga, samt anpassar dokumentet till         %%
%%    THS grafiska profil som den såg ut 2011. (Paktetet upp-       %%
%%    dateras lämpligen när den grafiska profilen gör det).         %%
%%                                                                  %%
%%    För att kunna använda klassen krävs att dokumentet kom-       %%
%%    pileras i XeLaTeX, som bl.a. finns på skolans system, och     %%
%%    inkluderas i varje godtycklig version av TeX Live-distribu-   %%
%%    tionen, samt MiKTeX                                           %%
%%                                                                  %%
%%    Klassen har en tillhörande tex-fil som heter fstildok.tex     %%
%%    innehållande beskrivningar till samtliga funktioner           %%
%%    i klassen.                                                    %%
%%                                                                  %%
%%    KLASSEN BESTÅR AV:                                            %%
%%    1. PAKET FÖR OPTION	PROCESSING           L.61                 %%
%%    2. INTRODUCERA VARIABLER                 L.77                 %%
%%    3. OPTIONS FÖR FSTIL                     L.119                %%
%%    4. POST-PROCESS OPTIONS                  L.180                %%
%%    5. PAKET                                 L.201                %%
%%    6. INSTÄLLNINGAR FÖR FONTER              L.258                %%
%%    7. SEKTIONSRELATERADE FUNKTIONER         L.291                %%
%%    8. TABLE OF CONTENT                      L.326                %%
%%    9. TITELSIDA                             L.400                %%
%%    10. SIDHUVUD & SIDFOT                    L.535                %%
%%    11. UNDERSKRIFTER                        L.655                %%
%%    12. VERIFIKATIONER                       L.720                %%
%%    13. MOTIONER                             L.784                %%
%%    14. LISTLIJÖ FÖR PARAGRAFER              L.858                %%
%%    15. ÄNDRINGSHISTORIK                     L.938                %%
%%                                                                  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fstildok}
\renewcommand\@currname{fstildok}



%====================================%
%   FÖRSTA OMGÅNG PAKET SOM BEHÖVS   %
%      FÖR OPTION PROCESSING ETC     %
%====================================%
%kvoption: För att kunna ta emot options på formatet key=value
\RequirePackage{kvoptions}
%\SetupKeyvalOptions{family=fstildok,prefix=}
%keyval: 
\RequirePackage{keyval}
%etoolbox: (bland annat) för logisk programering med booleans
\RequirePackage{etoolbox}
%pgffor: Gör det möjligt att loopa över commandon i listor med \foreach
\RequirePackage{pgffor}



%========================%
% INTRODUCERA VARIABLER  %
%========================%
% Switch på vilken doc-typ det är.
% Default är "vanlig" (isdoc) men alla ska vara false här!
\newtoggle{isstadgar}
\togglefalse{isstadgar}
\newtoggle{ispm}
\togglefalse{ispm}
\newtoggle{isallapm}
\togglefalse{isallapm}
\newtoggle{isdoc}
\togglefalse{isdoc}
\newcounter{nrofDocTypes}
\defcounter{nrofDocTypes}{0}

\newtoggle{IsLscape}
\togglefalse{IsLscape} %Har portrait som default

\newtoggle{DateTitle}
\togglefalse{DateTitle} %Per standard har man inte med datumet i tideln

\newtoggle{BigLogo}
\togglefalse{BigLogo} % Loggan är liten som default

\newtoggle{HeadIsFancy}
\toggletrue{HeadIsFancy} % Mycket info i siduvud/sidfot som default

\newtoggle{ChangeTheFont}
\toggletrue{ChangeTheFont} %Per standard använder man den font som ingår, kan man inte installera den kan detta vara bra att använda

\newtoggle{RemovePageNumbering}
\togglefalse{RemovePageNumbering} % Per standard används sidnumrering men till dokument där det inte behövs kan man stänga av den.

\newtoggle{fkmDocument} % Ifall det är ett internt fkm* dokument
\togglefalse{fkmDocument}

\newcommand{\titleImg}{kugghjul} % Definierar vilken bild som ska visas när \ftitlepage används.
\newcommand\logoname{{F_head_logo_noshadow}}



%=====================================%
%         OPTIONS FÖR FSTILDOK        %
%=====================================%
% Options till babel
\DeclareStringOption[swedish]{language}

\DeclareOption{doc}{
  \toggletrue{isdoc}
  \addtocounter{nrofDocTypes}{1}
}
\DeclareOption{pm}{
  \toggletrue{ispm}
  \addtocounter{nrofDocTypes}{1}
}
\DeclareOption{allapm}{
  \toggletrue{isallapm}
  \addtocounter{nrofDocTypes}{1}
}
\DeclareOption{stadgar}{
  \toggletrue{isstadgar}
  \addtocounter{nrofDocTypes}{1}
}


%Tar med det angivna datumet på titelsidan och högerjusterar allt
\DeclareOption{DateOnTitle}{\toggletrue{DateTitle}}

% Gör loggan uppe i högra hörnet större
\DeclareOption{BigLogo}{\toggletrue{BigLogo}}

%Ger möjlighet till en mer avskalad sidmall, med mindre info i sidhuvud och sidfot
\DeclareOption{plain}{\togglefalse{HeadIsFancy}}

%Om man inte vill att fstil ska använda Garamond för att man tex inte kan installera den (MAC har problem med det)
\DeclareOption{NoFontChange}{\togglefalse{ChangeTheFont}}


% Tar bort sidnumrering
\DeclareOption{NoPageNumbering}{\toggletrue{RemovePageNumbering}}


%Gör det möjligt att få till 'landscape'
\DeclareOption{landscape}{
\toggletrue{IsLscape}
\PassOptionsToClass{\CurrentOption}{article}
\PassOptionsToPackage{\CurrentOption}{geomerty}
}

% Gör om layout enligt fkm*s grafiska profil
\DeclareOption{fkm}{%
  \toggletrue{fkmDocument}%
  \renewcommand{\titleImg}{kugghjul_fkm.pdf}%
  \renewcommand\logoname{{fkmlogo.pdf}}
}


% Processa alla options
\ProcessKeyvalOptions{\@currname}
\ProcessOptions


%========================%
%  Post-process options  %
%========================%

%Kolla att bara en document type är använd
%samt sätt "doc" som default om det inte är någon given
\ifnumcomp{\value{nrofDocTypes}}{=}{0}
{\toggletrue{isdoc}}
{}
\ifnumcomp{\value{nrofDocTypes}}{>}{1}
{\ClassError{\@currname}{Du har engivit mer än 1 dokument typ!}}
{}

%Ger ett Class Error om man skickar in ett option som inte används (antagligen fel)
\foreach \x in \@unusedoptionlist {
\ClassError{\@currname}{The specified option `\x' is not supported! Kolla om du stavat fel eller titta i Guiden vilka options som fungerar.}
}
\makeatother



%=====================================%
%   PAKET SOM BEHÖVS FÖR ATT RESTEN   %
%    AV KLASSEN SKA FUNGERA           %
%    (eller som bara är grymma...)    %
%=====================================%
\LoadClass[10pt,a4paper]{article}

\makeatletter
\typeout{\@currname}

% babel: Avstavning, rubriker på innehållsförteckning m.m., språkanpassat
\RequirePackage[\fstildok@language]{babel}
\makeatother
%fancyhdr: ger kontroll på sidhuvud och sidfot
\RequirePackage{fancyhdr}
%lastpage: för att kunna referera till sista sidan
\RequirePackage{lastpage}
% amsmath, amssymb: Kommandon och tecken för matte på alla möjliga sätt
\RequirePackage{amsmath}
\RequirePackage{amssymb}
%amsfonts: innehåller bl.a. mathfrak, som krävs för att skriva ett Fysik-F
\RequirePackage{amsfonts}
% multirow, multicol: Tabellceller som spänner över flera rader/kolumner
\RequirePackage{multirow}
\RequirePackage{multicol}
% titlesec, enumitem, tocloft: Ger mer kontroll över numrering av sektioner och listor
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{tocloft}
%titletoc, titlesec: Intällningar på tielsida och tableofcontents samt numrering av sections
\RequirePackage{titletoc}
%graphicx: hanterar bilder
\RequirePackage{graphicx}
%fontspec: Intsällningar för typsnitt
\RequirePackage{fontspec}
%textcase: För att kunna göra UPPERCASE
%Gör att kommandot \NoCaseChange{} kan användas runt syntax, för att skydda den.
\RequirePackage{textcase}
%geometry: Anpassa sidmarginalerna för att använda ett helt A4
\RequirePackage[a4paper]{geometry}
%parskipp: Låt styckesbrytning markeras med blankrad istället för indrag
\RequirePackage[parfill]{parskip}
%calc: För att räkna! Typ \withof
\RequirePackage{calc}
%caption:Ger kontroll av figure-captions
\RequirePackage{caption}
%array: Mer options för arrays och alignment
\RequirePackage{array}
%tabularx: Definierar ett environment, tabularx, som är en modifierad version av tabular
\RequirePackage{tabularx}
%color: Tillåter definition av färger och användning av standard färger genom namnangivelser
\RequirePackage[usenames,dvipsnames]{color}
% hyperref: Skapar bokmärken i pdf-filer, gör hänvisningar till länkar, mm
\RequirePackage[bookmarks=true,colorlinks=true,linkcolor=textgray,urlcolor=textgray,linktoc=section]{hyperref}



%==============================%
%    INSTÄLLNINGAR FÖR FONTER  %
%==============================%
% Välj rätt typsnitt till brödtext och rubriker.
\defaultfontfeatures{Ligatures=TeX}
\iftoggle{ChangeTheFont}{%Om man ska ändra fonten, gör det!
\setmainfont{Garamond-Normal}
\newfontfamily\headingfont{Century Gothic}
}
{%Om man inte ska ändra fonten, definiera i alla fall upp \headingfont
\newfontfamily\headingfont{Latin Modern Roman}
}

% Skapar en ny section nivå. \subsubsubsection som bl.a. används i §1.10.4.1 i Stadgan
\titleclass{\subsubsubsection}{straight}[\subsection]
\newcounter{subsubsubsection}[subsubsection]


% Ställ typsnitt och spacing för rubriker
\titleformat*{\section}{\headingfont\fontsize{16}{18}\selectfont\bfseries}
\titlespacing{\section}{0pt}{*2}{0pt}
\titleformat*{\subsection}{\headingfont\fontsize{14}{16}\selectfont}
\titlespacing{\subsection}{0pt}{*2}{-2pt}

\titleformat*{\subsubsection}{\headingfont\fontsize{12}{14}\itshape}
\titlespacing{\subsubsection}{0pt}{*2}{-5pt}

\titleformat{\subsubsubsection}{\headingfont\normalsize\itshape\selectfont}{\thesubsubsubsection}{1em}{}
\titlespacing*{\subsubsubsection}{0pt}{*2}{-5pt}
\makeatletter
\def\toclevel@subsubsubsection{4}
\makeatother

%=====================================%
%   SEKTIONSRELATERADE KOMMANDON      %
%=====================================%
%Definiera färgen "fysik", enligt stadgarnas CMYK-definition.
\definecolor{fysik}{cmyk}{0.000, 0.608, 0.831, 0.000}
%Definiera färgen "orange", enligt stadgarnas definition
%\definecolor{orange}{wave}{612.2}
%\definecolor{dark-blue}{rgb}{0,0,.1}
\definecolor{textgray}{gray}{0.4} %Definierar en gråfärg som är 40% svart,  används i header och footer


%Definierar \F  =>  ett snyggt Fysik-F
\newcommand\F{\ensuremath{\mathfrak{F}}}

%Definierar \noll  =>  nØll, för att kunna skriva nØllan, nØllegasque etc.
\newcommand\noll{n\O ll}

%Definierar \fkm  =>  fkm*-logga
\newcommand\fkm{\ensuremath{\mathrm{\raisebox{-0.1ex}{\protect\rotatebox{22}{\textnormal{f}}}\!\raisebox{0.2ex}{\protect\rotatebox{-15}{\textnormal{k}}}\!\textnormal{m}\!^{*}}}}

%Definierar \FN => fn-logga
\newcommand\FN{\ensuremath{\F_{\!_{{N}}}}}

% Definierar \cda => cda's titel utskriven
\DeclareRobustCommand{\cda}{Charg\'e d'Affaires}

%Definierar \strike{text} => texten i överstruken font
\newlength{\strilen}
\newcommand{\strike}[1]{\setlength{\strilen}{\widthof{#1}}
\mbox{\raisebox{0.5ex}{\protect\rule{\strilen}{0.2ex}}\protect\hspace{-\strilen}#1\ }}





%========================%
% INSTÄLLNINGAR FÖR TOC  %
%========================%
\ifboolexpr{togl {isstadgar} or togl {isallapm} or togl {ispm}}{ % Table of Content (STADGAR, PM, ALLAPM)
%Formatering av section
\makeatletter
\def\l@section#1#2{\pagebreak[3] % Tagen från https://latex.org/forum/viewtopic.php?t=21336
    \vskip 1.0em plus 1pt  % space above chapter line
    \@tempdima 1.5em       % width of box holding chapter number
    \begingroup
      \parindent \z@ \rightskip \@pnumwidth
      \parfillskip -\@pnumwidth
      \bfseries            % Boldface removed.
      \leavevmode          % TeX command to enter horizontal mode.
      #1\hfil \hbox to\@pnumwidth{\hss #2}\medskip\par%% <= \medskip inserted
    \endgroup}
\makeatother

%Formatering av subsection
\titlecontents{subsection}
[5em]
{}
{\contentslabel{3.3em}}
{\hspace*{-2.3em}}
{\titlerule*[2pc]{}\contentspage}

%Formatering av subsubsection
\titlecontents{subsubsection}
[7.5em]
{}
{\contentslabel{4.3em}}
{\hspace*{-2.3em}}
{\titlerule*[2pc]{}\contentspage}

%Formatering av subsubsubsection
\titlecontents{subsubsubsection}
[10em]
{}
{\contentslabel{5.3em}}
{\hspace*{-2.3em}}
{\titlerule*[2pc]{}\contentspage}

% toc är tre nivåer djup. Alltså \section, \subsections och \subsubsection
\setcounter{tocdepth}{4}
%Sätter sektionsnumreringen till 3 djup. (-2 för att ta bort den)
\setcounter{secnumdepth}{4}
}{ %VANLIGT DOKUMENT
%Formatering av section
\titlecontents{section}
[2.5em]
{}
{\contentslabel{2.3em}}
{\hspace*{-2.3em}}
{\titlerule*[3pc]{}\contentspage}

%Formatering av subsection
\titlecontents{subsection}
[4.5em]
{}
{\contentslabel{2.3em}}
{\hspace*{-2.3em}}
{\titlerule*[4pc]{}\contentspage}

%Endast \section i toc (inte \subsections, etc.)
\setcounter{tocdepth}{1}
%Slår av sektionsnumreringen
\setcounter{secnumdepth}{-2}
}

% Kommando för innehållsförteckning med bokmärke i PDF-filen
%Definierar \ftoc	(fixar färgen också, vill inte ha den grå som andra länkar!)
\newcommand\ftoc{\pdfbookmark[2]{Innehåll}{toc}
\hypersetup{linkcolor=Black}\tableofcontents
\hypersetup{linkcolor=textgray}\newpage}



%========================%
%       TITELSIDA        %
%========================%
% Sätt egenskaper av PDF "rätt"
\newcommand\frontmatter{
    % Sidnummer i romerska siffor
    \pagenumbering{roman}
    \pagestyle{plain}
}
\newcommand\mainmatter{
    % Sidnummer i arabiska siffror
    \pagenumbering{arabic}
    \pagestyle{fstil_page}
}


%%%Definierar \ftitlepage
\makeatletter
\newcommand\ftitlepage[1][]{
\hypersetup{pdftitle={\@title}, pdfauthor={\@author}}
\thispagestyle{empty}
\pagecolor{fysik}
\iftoggle{IsLscape}
{% ÄR LANDSCAPE
\ifstrempty{#1}{
\hspace{-3in}{\makebox[\paperheight][r]{\raisebox{0pt}[10cm]{
\includegraphics[width=1.5\textheight]{\titleImg}
}}}
}{
\hspace{-3in}{\makebox[\paperheight][c]{\raisebox{0pt}[10cm]{
\includegraphics[width=\paperheight]{#1}
}}}
}
\vspace{0.2in}

\hspace{-\oddsidemargin}\hspace{-1in}\makebox[\paperwidth][c]{\raisebox{0pt}[0cm][0.5in]{

\colorbox{white}{\makebox[\paperwidth][c]{\raisebox{0pt}[0cm][\paperheight]{
\begin{minipage}[0]{\textwidth}
\vspace{1.9in}
\iftoggle{DateTitle}
{% ÄR DATE ON TITLE
\begin{flushright}
{
\headingfont\fontsize{30}{36}\selectfont\bfseries\MakeTextUppercase\@title\par\vspace{0.1cm} \ifdefstring{\@date}{}{}{\@date\par\vspace{0.5cm}}
}
\end{flushright}
}{% INTE DATE ON TITLE
{\headingfont\fontsize{30}{36}\selectfont\bfseries\MakeTextUppercase\@title\par\vspace{0.1cm}}
}

{ \headingfont\@styrdokdate\@fintro }
\end{minipage}
}}}
}}
} %LANDSCAPE END
{ %ÄR PORTRAIT
% Två hårdkodade sätt att inkludera en bild på titelsidan.
%
% Standard placering av bilden för titelsidan. Används oftast med bilden: kugghjul
\ifstrempty{#1}{
\hspace{-\oddsidemargin}\hspace{-1in}{\makebox[\paperwidth][r]{\raisebox{0pt}[14cm]{%
\includegraphics[width=2\textwidth]{\titleImg}%
}}}
}{
% Placerar en centrerad bild som har papperets bredd.
\hspace{-\oddsidemargin}\hspace{-1in}{\makebox[\paperwidth][c]{\raisebox{0pt}[14cm]{%
\includegraphics[width=\paperwidth]{#1}%
}}}
}
\vspace{0.5in}

\hspace{-\oddsidemargin}\hspace{-1in}\makebox[\paperwidth][c]{\raisebox{0pt}[0cm][0.5in]{

\colorbox{white}{\makebox[\paperwidth][c]{\raisebox{0pt}[0cm][\paperheight]{
\begin{minipage}[0]{\textwidth}
\vspace{3in}

\begin{flushright}
\iftoggle{DateTitle}
{% ÄR DATE ON TITLE
{
\headingfont\fontsize{30}{36}\selectfont\bfseries\MakeTextUppercase\@title\par \vspace{0.1cm} \ifdefstring{\@date}{}{}{\@date \par\vspace{0.5cm}}
}
} {% INTE DATE ON TITLE
{\headingfont\fontsize{30}{36}\selectfont\bfseries\MakeTextUppercase\@title\par\vspace{0.1cm}}
}
{ \headingfont \@styrdokdate\vspace{0.5cm}\@fintro }
\end{flushright}
\end{minipage}
}}}

}}
} %PORTRAIT END
\newpage
\pagecolor{White}
\ifboolexpr{togl {isstadgar} or togl {isallapm}}{ % Stadgar eller alla pm (lång titelsida, innehållsförteckning etc)
\frontmatter
% Visa bara ändringshistoriken först för stadgar
\ifboolexpr{togl {isstadgar}}{\showhistory}{}
\newpage
\ftoc
\mainmatter
}
{\ifboolexpr{togl {ispm}}{% Bara ett PM (Titelsida med ändringshistorik)
            \showhistory
            %\thispagestyle{empty}
}{}
}
}
\makeatother
%%%ftitlepage end

%Definierar \fintro{<Introduktionstext på förstasidan>}
%Ger ett blankslag om ej definierat i dokumentet
\makeatletter
\newcommand\fintro[1]{\def\@fintro{#1} }
\@ifundefined{@fintro}{\fintro{ } }{}
\makeatother


%Definierar ett MACRO som sätter redigeringsdatumet på framsidan om det är styrdokument.
\makeatletter
\ifboolexpr{togl {isstadgar} or togl {isallapm} or togl {ispm}}
{
\def\@styrdokdate{\fontsize{20}{24}\selectfont\textcolor{textgray}{ Fysiksektionen, THS} \par
\textcolor{textgray}{\fontsize{12}{14}\itshape\selectfont Senast uppdaterat \@lastchanged}\par}
}
{
\def\@styrdokdate{}
}
\makeatother



%========================================%
%  INSTÄLLNINGAR FÖR SIDHUVUD & SIDFOT	 %
%========================================%


\setlength\headheight{70pt} % Default är 12 pt, men detta passar bra till loggan
\newlength\logowidth
\newlength\logoheight
\newlength\logoxoffset
\setlength\logoxoffset{0pt}
\addtolength\voffset{-0.5in}
\iftoggle{BigLogo}
{
 \setlength\logowidth{\headheight}
 \setlength\headheight{127pt}
 \setlength\logoheight{\headheight}
 \addtolength\logoxoffset{20pt}
 \addtolength\textheight{-40pt}
}
{
 \setlength\logowidth{.55\headheight}
 \setlength\logoheight{\headheight}
}

\iftoggle{IsLscape} %Liten justering om Landscape
{
\addtolength\voffset{0.5in}
\addtolength{\textheight}{-0.5in}
}{}



\makeatletter
\fancypagestyle{fstil_page}{%DEFINE A NEW PAGE STYLE
  \pagenumbering{arabic} % Arabiska siffror i sidnumreringen
  \fancyhf{}
  

\renewcommand\headrulewidth{0pt}

\setlength\headsep{.5\logowidth}

\fancyheadoffset[R]{.7\logowidth}


\fancyhead[R]{\raisebox{-0.5\height}{\includegraphics[height=\logoheight]{\logoname}}\hspace{\logoxoffset}}


\fancyhead[L]{%
  \iftoggle{HeadIsFancy}{%
    \textcolor{textgray}{%
      \iftoggle{IsLscape}{\biggerskip}{} % Rättar till placeringen av sidhuvudet för liggande
      \headingfont\textbf{%
	      \ifboolexpr{togl {ispm} or togl {isstadgar} or togl {isallapm}}
		      {Fysiksektionens \@title\\%
		      \@lastchanged\\}
		      {\@title\\}
      }
      \ifdefstring{\@date}{}{%Om @date är en tom sträng, skriv inte den raden
        }{%Annars skriv ut datumet
        \@date\\}
      \iftoggle{RemovePageNumbering}{}{%
        Sid. \thepage~ av { \pageref{LastPage}} }
    }
  }{}
}



\fancyhead[C]{}

\fancyfoot[C]{
  \iftoggle{HeadIsFancy}{%
    \rule{\textwidth}{0.75pt}
    \textcolor{fysik}{
      \footnotesize
      \begin{center}
        \begin{tabular}{p{0.25\paperwidth}p{0.15\paperwidth}p{0.15\paperwidth}p{0.15\paperwidth}}
          Postadress: & Organisationsnummer: & Besöksadress: & Hemsida: \\
          \F ysiksektionen, THS 100 44 Stockholm &   802411-8948 &   Brinellvägen 89  & { \href{http://www.f.kth.se}
          {www.f.kth.se} }
        \end{tabular}
      \end{center}
    }
  }{}
}
\makeatother

\fancyfoot[L]{}
\fancyfoot[R]{}
}% END fstil_page PAGESTYLE


\makeatletter
\fancypagestyle{plain}{%REDEFINE THE PLAIN PAGE STYLE
    \pagestyle{fstil_page}
    
    \ifboolexpr{togl {isstadgar} or togl {isallapm}}{
      \pagenumbering{roman} % Rommerska siffror i sidnumreringen
      \fancyhead[L]{%
        \iftoggle{HeadIsFancy}{%
          \textcolor{textgray}{%
		        \headingfont\textbf{%
  			    Fysiksektionens \@title\\
	  		    \@lastchanged\\
		      }
          \ifdefstring{\@date}{}{%Om @date är en tom sträng, skriv inte den raden
            }{%Annars skriv ut datumet
            \@date\\}
          \iftoggle{RemovePageNumbering}{}{%
            Sid. \thepage~ av { \pageref{LastPage}} }
          }
        }{}
      }
    }{}
}% END plain PAGESTYLE 

\makeatother


%====================================%
%           UNDERSKRIFTER            %
%====================================%
%Kommandon för att generera snygga underskrifter
%\sign{plats}{år}{namn}{titel}
\newcommand{\sign}[4]{
\begin{center}
\begin{tabular}{>{\centering}p{5cm}}
#1  \tabularnewline
den \hspace{.5cm}/\hspace{.5cm} #2  \tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
#3 \tabularnewline
#4
\end{tabular}
\end{center}}

%\twosign{plats}{år}{namn1}{namn2}{titel1}{titel2}
\newcommand{\twosign}[6]{
\begin{center}
\begin{tabular}{>{\centering}p{4cm}p{5mm}>{\centering}p{4cm}p{5mm}}
#1 && #1  \tabularnewline
den \hspace{.5cm}/\hspace{.5cm} #2 && den \hspace{.5cm}/\hspace{.5cm} #2  \tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
#3 && #4 \tabularnewline
#5 && #6
\end{tabular}
\end{center}}

%\threesign{plats}{år}{namn1}{namn2}{namn3}{titel1}{titel2}{titel3}
\newcommand{\threesign}[8]{
\begin{center}
\begin{tabular}{>{\centering}p{3.1cm}p{5mm}>{\centering}p{3.1cm}p{5mm}>{\centering}p{3.1cm}}
#1 && #1 && #1  \tabularnewline
den \hspace{.5cm}/\hspace{.5cm} #2 && den \hspace{.5cm}/\hspace{.5cm} #2 && den \hspace{.5cm}/\hspace{.5cm} #2 \tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
#3 && #4 && #5 \tabularnewline
#6 && #7 && #8
\end{tabular}
\end{center}}

%\foursign{år}{namn1}{namn2}{namn3}{namn4]{titel1}{titel2}{titel3}{titel4}
%TeX tillåter bara 9 indata, så Stockholm är automatiskt platsen i detta kommando.
\newcommand{\foursign}[9]{
\begin{center}
\begin{tabular}{>{\centering}p{2.7cm}p{5mm}>{\centering}p{2.7cm}p{5mm}>{\centering}p{2.7cm}p{5mm}>{\centering}p{2.7cm}}
Stockholm && Stockholm && Stockholm && Stockholm \tabularnewline
den \hspace{.5cm}/\hspace{.5cm} #1 && den \hspace{.5cm}/\hspace{.5cm} #1 && den \hspace{.5cm}/\hspace{.5cm} #1 && den \hspace{.5cm}/\hspace{.5cm} #1 \tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
\tabularnewline
#2 && #3 && #4 && #5\tabularnewline
#6 && #7 && #8 && #9
\end{tabular}
\end{center}}

%=======================================%
%     Kommandon för verifikationer      %
%=======================================%

%\attest{namn och titel för sakattest}{namn och titel för ekonomisk attest} skapar raderna för attestering
\newcommand{\attest}[2]{
\begin{tabular}{p{6.2cm}p{1cm}p{6.2cm}}
Sakattest & & Ekonomisk attest\\
\tabularnewline
\tabularnewline
\vspace{1.5cm} \\
\rule{6.3cm}{0.5pt} & & \rule{6.3cm}{0.5pt} \\
{\small #1} & & {\small #2}
\end{tabular}}

%\verifikat{beskrivning} lägger till bokförings- och verifikationsdatum, samt verifikationsnummer. Beskrivning är t.ex. nämnd 
\newcommand{\verifikat}[1]{
\begin{Large}{\bf VERIFIKATION} - #1\end{Large}\\\\
%\flushleft
\vspace{0.5cm}
\begin{tabular}{llp{8mm}ll}
Verifikationsnummer:&\rule[-.4\baselineskip]{1.8cm}{.5pt}&&Verifikationsdatum:&\rule[-.4\baselineskip]{2.5cm}{.5pt}\\
\\
&&&Bokföringsdatum:&\rule[-.4\baselineskip]{2.5cm}{.5pt}\\
\end{tabular}}

%\utlägg{beskrivning} skapar grunden för ett utläggsverifikat
\newcommand{\utlägg}[1]{
\verifikat{#1}\\
\textrad{Namn}\\
\textrad{Konto (inkl clearingnr):}\\
\textrad{Bank:}\\
\textrad{Belopp:}\\
\textrad{Beskrivning:}\\
\textrad{}\\
\textrad{}\\
Fyll i de fem rubrikerna ovan $\&$ fäst kvittot/fakturan synligt på baksidan.}

%\textrad{text} ger texten på raden
\newcommand{\textrad}[1]{
{\renewcommand{\arraystretch}{2}
\begin{tabular}{p{0.67\paperwidth}}
\large{#1}\\
\hline
\end{tabular}}}


%\ekostart börjar tabellen med bokföringskonton, RS samt Kredit och debet. 
\newcommand{\ekostart}{\begin{tabular}{|p{6.7cm}|p{.8cm}|p{.4cm}|p{1cm}|p{1.6cm}|p{1.6cm}|}
    \hline
        \large{Kontonamn} &\small{Konto}& \small{RS} & \small{Projekt} & \large{Debet} & \large{Kredit} \\
    \hline}
    
%\ekorad{kontonamn}{kontonummer} skapar en rad
\newcommand{\ekorad}[2]{
\hline
#1&#2& & & & \\}

%\ekoslut avslutar tabellen och lägger till total
\newcommand{\ekoslut}{\hline
        \multicolumn{4}{|r|}{\raisebox{-1pt}{TOTALT}} & \vspace{.6\baselineskip} & \\
    \hline
  \end{tabular}}

%================================%
%     Kommandon för motioner     %
%================================%
\makeatletter
\newcommand{\@biggerskip}
    {
    \vskip 1cm
    }

\newcommand{\@yrkande}[1]{\begin{itemize}#1\end{itemize}}

\newcommand{\att}[1]{{\bfseries $\text{att}_{#1}$}}

\newcounter{attcount}
\setcounter{attcount}{0}
\newcommand\attsats{\addtocounter{attcount}{1} \item [\att{\arabic{attcount}}] }
\newcommand\attsatser[1]{\def\@attsatser{#1}}
\@ifundefined{@attsatser}{\attsatser{ }}{}
\newcommand\rubrik[1]{\def\@rubrik{#1}}
\@ifundefined{@rubrik}{\rubrik{ }}{}
\newcommand\typ[1]{\def\@typ{#1}}
\@ifundefined{@typ}{\typ{ }}{}
\newcommand\smdate[1]{\def\@smdate{#1}}
\@ifundefined{@smdate}{\smdate{ }}{}
\newcommand\smnr[1]{\def\@smnr{#1}}
\@ifundefined{@smnr}{\smnr{ }}{}
\newcommand\name[1]{\def\@name{#1}}
\@ifundefined{@name}{\name{ }}{}
\newcommand\bakgrund[1]{\def\@bakgrund{#1}}
\@ifundefined{@bakgrund}{\bakgrund{ }}{}

\newcommand\iorwe[1]{\def\@iorwe{#1}}
\@ifundefined{@iorwe}{\iorwe{ }}{}
\newcommand\group[1]{\def\@group{#1}}
\newcommand\@signatur{
\@ifundefined{@group}{\iorwe{Jag}}{\ifstrempty{\@group}
{\iorwe{Jag}} %Om \group är tom, skriv inget
{\iorwe{Vi}%
\@group\ genom
\@biggerskip}} % annars skriv ut vilken grupp det är

  \begin{tabular}[t]{c}
  	\@name
  \end{tabular}
}

\newcommand{\motion}{
\title{\@rubrik}
\date{\@smdate}
\author{Fysiksektionen, THS}
\begin{document}
\thispagestyle{fancy}

\section{\@typ\ till SM\@smnr\ \@smdate}

\subsection{\@rubrik}

\subsubsection{Bakgrund}
\@bakgrund

\subsubsection{\@typ}
\@iorwe yrkar därför på:

\@yrkande{\@attsatser}
\bigskip
\@signatur

\end{document}
}
\makeatother

%=======================================%
%      LISTMILJÖER FÖR PARAGRAFER       %
%=======================================%
\newenvironment{punkter}{\begin{itemize}}{\end{itemize}}
\newcommand\punkt{\normalfont\item}
\newcommand\fetpunkt{\normalfont\item\bfseries}
\newcommand\attpunkt{\normalfont\item[\textbf{att}\ ]}
\newcommand\tompunkt{\normalfont\item[\hspace{1em}]}

\newcommand\paragraf[1]{#1 \S}
\newcommand\setupenumerate[3]{
    \setenumerate[#1]{label={#2 #3},leftmargin=6em}
}

\newcommand\resetpunkter{\setupenumerate{1}{\arabic*~\S~}{}}

\setlength\cftsecnumwidth{2.2em}
\setlength\cftsubsecnumwidth{4em}




\ifboolexpr{togl {ispm} or togl {isstadgar}} % STADGAR ELLER PM
{
    \renewcommand\thesection{\arabic{section}~\S~}
    \renewcommand\thesubsection{\arabic{section}.\arabic{subsection}~\S~}
    \renewcommand\thesubsubsection{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}~\S~}
	\renewcommand\thesubsubsubsection{\arabic{section}.\arabic{subsection}.\arabic{subsubsection}.\arabic{subsubsubsection}~\S~}
    \newcommand\header[1]
    {
        \section{#1}
        \setupenumerate{1}{\thesection}{\arabic*.}
    }
    \newcommand\subheader[1]
    {
        \subsection{#1}
        \setupenumerate{1}{\thesection}{\arabic{subsection}.\arabic*.}
    }
    \newcommand\subsubheader[1]
    {
        \subsubsection{#1}
        \setupenumerate{1}{\thesubsection}{\arabic{subsubsection}.\arabic*.}
    }
}{}


\ifboolexpr{togl {isallapm}} % ALLA PM
{
    \renewcommand\thesubsection{\arabic{subsection}~\S~}
    \titleformat{\section}{\bf \sc \Large}{}{0em}{}
    \renewcommand\thesubsubsection{\thesubsection\ \arabic{subsubsection}}
    \setupenumerate{1}{\arabic.~\S~}{}

    \newcommand\header[1]
    {
        \subsection{#1}
        \setupenumerate{1}{\thesubsection}{\arabic*.}
    }
    \newcommand\subheader[1]
    {
        \subsubsection{#1}
        \setupenumerate{1}{\thesubsubsection}{\arabic*.}
    }
    
    \newcommand\pminput[2]{
        \newpage
        \section{#1}
        \resetpunkter
        \input{#2}
        \showhistory
    }
}
{}

\setenumerate[2]{label*=\arabic*.}
\setenumerate[3]{label*=\arabic*.}
\setenumerate[4]{label*=\arabic*.}



% ======================== %
%      ÄNDRINGSHISTORIK    %
% ======================== %
\makeatletter

% Beskrivande text under rubriken Ändringshistorik
\newcommand\historydescription[1]{\def\@historydescription{#1} }
\@ifundefined{@historydescription}{\historydescription{ } }{}

% Lista över ändringar
\newcommand\changed[3]{#1 & #2 & #3\\}
\newcommand\lastchanged[1]{\def\@lastchanged{#1}}
\@ifundefined{@lastchanged}{\lastchanged{ }}{}
\newcommand\@history{}
\newcommand\history[1]{
\renewcommand\@history{
\begin{tabular}{lll}
Datum & Sammanträde & Avsnitt\\
%\hline
#1
\end{tabular}
}
}
\makeatother


\makeatletter
% Ändringshistorik
\ifboolexpr{togl {ispm} or togl {isstadgar}}
{
    \newcommand\showhistory{
    \section*{Ändringshistorik}
    \@historydescription \par
    \@history
    }
}
{
    \newcommand\showhistory{
    \subsection*{Ändringshistorik}
    \@historydescription \par
    \@history
    }
}
\makeatother



%====================================%
%  SE TILL ATT MAINMATTER ÄR AKTIV   %
%====================================%
\mainmatter