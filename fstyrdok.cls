\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fstyrdok}
\renewcommand\@currname{fstyrdok}

%kvoption: För att kunna ta emot options på formatet key=value
\RequirePackage{kvoptions}
%\SetupKeyvalOptions{family=fstyrdok,prefix=}
%keyval: 
\RequirePackage{keyval}
%etoolbox: (bland annat) för logisk programering med booleans
\RequirePackage{etoolbox}
%pgffor: Gör det möjligt att loopa över commandon i listor med \foreach
\RequirePackage{pgffor}




% ======================== %
%  INTRODUCERA VARIABLER   %
% ======================== %
% Switch på vilken doc-typ det är. Default är "vanlig"
\newtoggle{isstadgar}
\togglefalse{isstadgar}
\newtoggle{ispm}
\togglefalse{ispm}
\newtoggle{isallapm}
\togglefalse{isallapm}
\newtoggle{isdoc}
\toggletrue{isdoc}

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

%-----------------------------------------------------------%
%           OPTIONS FÖR KLASSEN FSEKT-STYRDOK               %
%-----------------------------------------------------------%
% Options till babel
% Defaultvärden är satta för att passa för dokument på svenska i skolans IT-miljö.
\DeclareStringOption[swedish]{language}

\DeclareStringOption[doc]{doctype}


%Tar med det angivna datumet på titelsidan och högerjusterar allt
\DeclareOption{DateOnTitle}{\toggletrue{DateTitle}}

% Gör loggan uppe i högra hörnet större
\DeclareOption{BigLogo}{\toggletrue{BigLogo}}

%Ger möjlighet till en mer avskalad sidmall, med mindre info i sidhuvud och sidfot
\DeclareOption{plain}{\togglefalse{HeadIsFancy}}

%Om man inte vill att fstil ska använda Garamond för att man tex inte kan installera den (MAC har problem med det)
\DeclareOption{NoFontChange}{\togglefalse{ChangeTheFont}}

%Gör det möjligt att få till 'landscape'
\DeclareOption{landscape}{\toggletrue{IsLscape}}


% Processa alla options
\ProcessKeyvalOptions{\@currname}
\ProcessOptions


% ======================== %
%   Post-process options   %
% ======================== %
% Makron för snabb koll mot de olika dokumenttyperna
\makeatletter

\ifdefstring{\fstyrdok@doctype}{stadgar}{
\toggletrue{isstadgar}
\@expandtwoargs\@removeelement{doctype=stadgar}{\@unusedoptionlist}{\@unusedoptionlist} %UGLY: Hard remove of "unused" option
}
{
\ifdefstring{\fstyrdok@doctype}{pm}{
\toggletrue{ispm}
\@expandtwoargs\@removeelement{doctype=pm}{\@unusedoptionlist}{\@unusedoptionlist} %UGLY: Hard remove of "unused" option
}
{
\ifdefstring{\fstyrdok@doctype}{allapm}{
\toggletrue{isallapm}
\@expandtwoargs\@removeelement{doctype=allapm}{\@unusedoptionlist}{\@unusedoptionlist} %UGLY: Hard remove of "unused" option
}
{
\ifdefstring{\fstyrdok@doctype}{doc}{
\toggletrue{isdoc}
\@expandtwoargs\@removeelement{doctype=doc}{\@unusedoptionlist}{\@unusedoptionlist} %UGLY: Hard remove of "unused" option
}
{
\ClassError
            {\@currname}
            {Felaktig dokumenttyp "\fstyrdok@doctype" angedd!}
            {Det måste vara en av de följande: "pm", "allapm" och "stadgar", och du anger en av dem som option till dokumentklassen "\@currname" genom att sätta "doctype=<sträng>".}
}
}
}
}


%Ger ett Class Error om man skickar in ett option som inte används (antagligen fel)
\foreach \x in \@unusedoptionlist {
\ClassError{\@currname}{The specified option `\x' is not supported! Kolla om du stavat fel eller titta i Guiden vilka options som fungerar.}
}
\makeatother



%-----------------------------------------------------------%
%           PAKET SOM BEHÖVS FÖR ATT RESTEN         %
%           AV KLASSEN SKA FUNGERA              %
%           (eller som bara är grymma...)           %
%-----------------------------------------------------------%
\LoadClass[10pt,a4paper]{article}

\makeatletter
\typeout{\@currname}

% babel: Avstavning, rubriker på innehållsförteckning m.m., språkanpassat
\RequirePackage[\fstyrdok@language]{babel}
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
\RequirePackage{geometry}
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
% xcolor: Gör färghantering mycket smidigare
\RequirePackage[hyperref]{xcolor}
% hyperref: Skapar bokmärken i pdf-filer, gör hänvisningar till länkar, mm
\RequirePackage[bookmarks=true,colorlinks=true,linkcolor=headernfooter,urlcolor=headernfooter,linktoc=section]{hyperref}


%========================%
%    INSTÄLLNINGAR FÖR FONTER       %
%========================%
% Välj rätt typsnitt till brödtext och rubriker.
\defaultfontfeatures{Ligatures=TeX}
\iftoggle{ChangeTheFont}{%Om man ska ändra fonten, gör det!
\setmainfont{Garamond-Normal}
\newfontfamily\headingfont{Century Gothic}}
{%Om man inte ska ändra fonten, definiera i alla fall upp \headingfont
\newfontfamily\headingfont{Latin Modern Roman}}

% Ställ typsnitt och spacing för rubriker
\titleformat*{\section}{\headingfont\fontsize{16}{18}\selectfont\bfseries}
%\titlespacing{\section}{0pt}{*2}{-5pt}
\titleformat*{\subsection}{\headingfont\fontsize{14}{16}\selectfont}

%\titlespacing{\subsection}{-4pt}{*0}{*1}

\titleformat*{\subsubsection}{\headingfont\itshape}
\titlespacing{\subsubsection}{0pt}{*2}{-5pt}





%-----------------------------------------------------------%
%           FÄLTDEFINITIONER OCH ANNAT          %
%           FÖR TITELSIDA, INNEHÅLSFÖRTECKNING      %
%           OCH ÄNDRINGSHSTORIK             %
%-----------------------------------------------------------%
\makeatletter

% Sidavdelare
\newcommand\HRule[1][1pt]{\rule{\linewidth}{#1}}

% \org{<organisation>}
\newcommand{\org}[1]{\def\@org{#1}}
\@ifundefined{@org}{\org{Fysiksektionen, THS}}{}

% Lista över ändringar
\newcommand\changed[3]{#1 & #2 & #3\\}
\newcommand\@history{}
\newcommand\history[1]{
\renewcommand\@history{
\begin{tabular}{lll}
Datum & Sammanträde & Avsnitt\\
\hline
#1
\end{tabular}
}
}

% Ny definiton av titel
\renewcommand\maketitle{
    \hypersetup{pdftitle={\@title},pdfauthor={\@author}}
    \begin{flushright}
    \includegraphics[width=3cm]{kugghjul}
    \vskip 2cm
    {\LARGE \textsc{\@title} \\ \HRule}
        {\large \@org}
    {\small\par Uppdaterat \@date}
  \end{flushright}
}

\newcommand\frontmatter{
    % Sidnummer i romerska siffor
    \pagenumbering{roman}
    \pagestyle{plain}
}
\newcommand\mainmatter{
    % Sidnummer i arabiska siffror
    \pagenumbering{arabic}
    \pagestyle{fancy}
}

% Kommando för innehållsförteckning med bokmärke i PDF-filen
\newcommand\ftoc{\pdfbookmark[2]{Innehåll}{toc}\tableofcontents}

% Enkelt kommando för titelblad och innehållsförteckning
\ifboolexpr{togl {isstadgar} or togl {isallapm}}
{ % Stadgar eller alla pm (lång titelsida, innehållsförteckning etc)
    \newcommand\ftitlepage
    {
        \begin{titlepage}
        \maketitle
        \newpage\frontmatter
        % Visa bara ändringshistoriken först för stadgar
        \ifboolexpr{togl {isstadgar}}{\showhistory}{}
        \ftoc
        \end{titlepage}
        \newpage\mainmatter
    }
}
{ % Bara ett PM (Titelsida med ändringshistorik)
    \newcommand\ftitlepage
    {
        \begin{titlepage}
            \maketitle
            \showhistory
            \thispagestyle{empty}
        \end{titlepage}
    }
}

% Ändringshistorik
\ifboolexpr{togl {ispm} or togl {isstadgar}}
{
    \newcommand\showhistory{
    \section*{Ändringshistorik}
    \@history
    }
}
{
    \newcommand\showhistory{
    \subsection*{Ändringshistorik}
    \@history
    }
}

\makeatother



%===============================%
%    INSTÄLLNINGAR FÖR SIDHUVUD OCH SIDFOT     %
%===============================%

\definecolor{headernfooter}{gray}{0.40} %Definierar en gråfärg som är 40% svart,  används i header och footer

\pagenumbering{arabic} % Arabiska siffror i sidnumreringen
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
\renewcommand\headrulewidth{0pt}


\setlength\headsep{.5\logowidth}

\fancyheadoffset[R]{.7\logowidth}

\newcommand\logoname{{F_head_logo_noshadow}}
\rhead{\raisebox{-0.5\height}{\includegraphics[height=\logoheight]{\logoname}}\hspace{\logoxoffset}}

\makeatletter
\lhead{%
\iftoggle{HeadIsFancy}{%
\textcolor{headernfooter}{%
\headingfont\textbf{\@title}\\
\ifdefstring{\@date}{}{%Om @date är en tom sträng, skriv inte den raden
}{%Annars skriv ut datumet
\@date\\}
Sid. \thepage~ av { \pageref{LastPage}} }
}{}
}
\makeatother

\chead{}
\cfoot{
\iftoggle{HeadIsFancy}{%
\rule{\textwidth}{0.75pt}
\textcolor{headernfooter}{
\footnotesize
\begin{center}
\begin{tabular}{p{0.25\paperwidth}p{0.15\paperwidth}p{0.15\paperwidth}p{0.15\paperwidth}}
Postadress: & Organisationsnummer: & Besöksadress: & Hemsida: \\
 \F ysiksektionen, THS 100 44 Stockholm &   802411-8948 &   Brinellvägen 89  & { \href{http://www.f.kth.se}{www.f.kth.se} }
\end{tabular}
\end{center}
}
}{}
}

\lfoot{}
\lfoot{}
\pagestyle{fancy}



%-----------------------------------------------------------%
%           LISTMILJÖER FÖR PARAGRAFER          %
%-----------------------------------------------------------%
\newenvironment{punkter}{\begin{enumerate}}{\end{enumerate}}
\newcommand\punkt{\normalfont\item}
\newcommand\fetpunkt{\normalfont\item\bfseries}
\newcommand\attpunkt{\normalfont\item\textbf{att}\ }
\newcommand\tompunkt{\normalfont\item\hspace{1em}}

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
    \renewcommand\thesubsection{\thesection~\arabic{subsection}.}
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
{
}

\setenumerate[2]{label*=\arabic*.}
\setenumerate[3]{label*=\arabic*.}
\setenumerate[4]{label*=\arabic*.}



%==========================%
%   SEKTIONSRELATERADE KOMMANDON      %
%==========================%
%Definiera färgen "fysik", enligt stadgarnas CMYK-definition.
\definecolor{fysik}{cmyk}{0.000, 0.608, 0.831, 0.000}
%Definiera färgen "orange", enligt stadgarnas definition
\definecolor{orange}{wave}{612.2}
\definecolor{dark-blue}{rgb}{0,0,.1}


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

%Definierar \carlsven => Calle Svensson i överstruken text.
\newcommand{\carlsven}{\strike{Calle Svensson}}


%==========================%
%      ANDRA ANVÄNDBARA KOMMANDON     %
%==========================%
%Definierar \strike{text} => texten i överstruken font
\newlength{\strilen}
\newcommand{\strike}[1]{\setlength{\strilen}{\widthof{#1}}
\mbox{\raisebox{0.5ex}{\protect\rule{\strilen}{0.2ex}}\protect\hspace{-\strilen}#1\ }}


%       UNDERSKRIFTER                %
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
