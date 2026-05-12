const fs = require('fs');
const path = require('path');
const dataDir = path.join(__dirname, 'assets', 'data');

// === AUTOCAD: Add descriptions to existing + add new entries ===
const acExisting = JSON.parse(fs.readFileSync(path.join(dataDir, 'autocad.json'), 'utf8'));

// Auto-generate description from shortcut and function
function acDesc(s, f) {
  const cmd = s.includes('+') ? s : s + ' + Enter';
  return `Press ${cmd} to activate ${f.split('—')[0].trim()} in AutoCAD.`;
}

// Add descriptions to all existing
acExisting.forEach(e => {
  if (!e.description) e.description = acDesc(e.shortcut, e.function);
});

// New AutoCAD entries
const acNew = [
  {id:"ac-148",shortcut:"TXTEXP",function:"Text Explode — Convert text to geometry",description:"Press TXTEXP + Enter to explode text objects into individual geometric entities."},
  {id:"ac-149",shortcut:"NCOPY",function:"Nested Copy — Copy from xref/block",description:"Press NCOPY + Enter to copy objects nested within blocks or xrefs."},
  {id:"ac-150",shortcut:"OOPS",function:"Oops — Restore last erased",description:"Press OOPS + Enter to restore the last erased object even after other commands."},
  {id:"ac-151",shortcut:"QDIM",function:"Quick Dimension — Auto dimensions",description:"Press QDIM + Enter to create multiple dimensions automatically at once."},
  {id:"ac-152",shortcut:"DIMSPACE",function:"Dimension Space — Even spacing",description:"Press DIMSPACE + Enter to evenly space parallel dimensions."},
  {id:"ac-153",shortcut:"DIMBREAK",function:"Dimension Break — Break dim lines",description:"Press DIMBREAK + Enter to break dimension lines where they cross objects."},
  {id:"ac-154",shortcut:"LEADER",function:"Leader — Draw leader annotation",description:"Press LEADER + Enter to create a leader line with annotation text."},
  {id:"ac-155",shortcut:"TOL",function:"Tolerance — Geometric tolerance",description:"Press TOL + Enter to insert geometric dimensioning and tolerancing symbols."},
  {id:"ac-156",shortcut:"MSPACE",function:"Model Space — Switch to model",description:"Press MSPACE + Enter to switch from paper space to model space in a viewport."},
  {id:"ac-157",shortcut:"PSPACE",function:"Paper Space — Switch to layout",description:"Press PSPACE + Enter to switch from model space to paper space."},
  {id:"ac-158",shortcut:"MVSETUP",function:"MV Setup — Configure viewports",description:"Press MVSETUP + Enter to set up and align model space viewports in layouts."},
  {id:"ac-159",shortcut:"PAGESETUP",function:"Page Setup Manager",description:"Press PAGESETUP + Enter to configure page layout settings for plotting."},
  {id:"ac-160",shortcut:"PLOT",function:"Plot — Send to printer/PDF",description:"Press PLOT + Enter to open the Plot dialog for printing or PDF export."},
  {id:"ac-161",shortcut:"PLOTTERMANAGER",function:"Plotter Manager — Configure plotters",description:"Press PLOTTERMANAGER + Enter to manage plotter configurations."},
  {id:"ac-162",shortcut:"RENDER",function:"Render — Generate 3D render",description:"Press RENDER + Enter to generate a photorealistic rendering of a 3D model."},
  {id:"ac-163",shortcut:"MAT",function:"Materials — Assign materials",description:"Press MAT + Enter to open the Materials Browser for assigning materials."},
  {id:"ac-164",shortcut:"LIGHT",function:"Light — Place light sources",description:"Press LIGHT + Enter to add point, spot, or distant lights to a 3D scene."},
  {id:"ac-165",shortcut:"SUN",function:"Sun Properties — Sun lighting",description:"Press SUN + Enter to configure sun angle and sky background for rendering."},
  {id:"ac-166",shortcut:"CAMERA",function:"Camera — Create named camera",description:"Press CAMERA + Enter to place a camera for a specific 3D view."},
  {id:"ac-167",shortcut:"BOX",function:"Box — 3D solid box",description:"Press BOX + Enter to create a 3D solid box primitive."},
  {id:"ac-168",shortcut:"SPHERE",function:"Sphere — 3D solid sphere",description:"Press SPHERE + Enter to create a 3D solid sphere primitive."},
  {id:"ac-169",shortcut:"CYL",function:"Cylinder — 3D solid cylinder",description:"Press CYL + Enter to create a 3D solid cylinder primitive."},
  {id:"ac-170",shortcut:"CONE",function:"Cone — 3D solid cone",description:"Press CONE + Enter to create a 3D solid cone primitive."},
  {id:"ac-171",shortcut:"WEDGE",function:"Wedge — 3D solid wedge",description:"Press WEDGE + Enter to create a 3D solid wedge primitive."},
  {id:"ac-172",shortcut:"TORUS",function:"Torus — 3D solid torus",description:"Press TORUS + Enter to create a 3D solid torus (donut) primitive."},
  {id:"ac-173",shortcut:"PYRAMID",function:"Pyramid — 3D solid pyramid",description:"Press PYRAMID + Enter to create a 3D solid pyramid with a polygon base."},
  {id:"ac-174",shortcut:"EXT",function:"Extrude — 3D from 2D profile",description:"Press EXT + Enter to create a 3D solid by extruding a 2D object."},
  {id:"ac-175",shortcut:"LOFT",function:"Loft — 3D from cross sections",description:"Press LOFT + Enter to create a 3D solid through a series of cross-section curves."},
  {id:"ac-176",shortcut:"SWEEP",function:"Sweep — 3D along path",description:"Press SWEEP + Enter to create a 3D solid by sweeping a profile along a path."},
  {id:"ac-177",shortcut:"PRESSPULL",function:"Press/Pull — Quick extrude",description:"Press PRESSPULL + Enter to push or pull bounded areas to create 3D geometry."},
  {id:"ac-178",shortcut:"UNION",function:"Union — Combine 3D solids",description:"Press UNION + Enter to combine two or more 3D solids into one."},
  {id:"ac-179",shortcut:"SUBTRACT",function:"Subtract — Remove 3D solid",description:"Press SUBTRACT + Enter to remove one 3D solid volume from another."},
  {id:"ac-180",shortcut:"INTERSECT",function:"Intersect — Common volume",description:"Press INTERSECT + Enter to create a solid from the overlapping volume of two solids."},
  {id:"ac-181",shortcut:"SLICE",function:"Slice — Cut 3D solid",description:"Press SLICE + Enter to cut a 3D solid along a specified plane."},
  {id:"ac-182",shortcut:"SECTION",function:"Section — Cross-section region",description:"Press SECTION + Enter to create a 2D region from a cross-section of a 3D solid."},
  {id:"ac-183",shortcut:"INTERFERE",function:"Interference — Check overlap",description:"Press INTERFERE + Enter to check for overlapping volumes between 3D solids."},
  {id:"ac-184",shortcut:"SOLIDEDIT",function:"Solid Edit — Modify 3D faces",description:"Press SOLIDEDIT + Enter to edit faces, edges, and bodies of 3D solids."},
  {id:"ac-185",shortcut:"FLATSHOT",function:"Flatshot — 2D from 3D view",description:"Press FLATSHOT + Enter to create a 2D representation of a 3D model."},
  {id:"ac-186",shortcut:"CONVTOSOLID",function:"Convert to Solid",description:"Press CONVTOSOLID + Enter to convert eligible objects to 3D solids."},
  {id:"ac-187",shortcut:"CONVTOSURFACE",function:"Convert to Surface",description:"Press CONVTOSURFACE + Enter to convert eligible objects to surfaces."},
  {id:"ac-188",shortcut:"MESH",function:"Mesh — Create mesh primitive",description:"Press MESH + Enter to create a 3D mesh primitive for organic modeling."},
  {id:"ac-189",shortcut:"SMOOTHMESHCONVERT",function:"Smooth Mesh Convert",description:"Press SMOOTHMESHCONVERT + Enter to convert mesh objects to smooth solids."},
  {id:"ac-190",shortcut:"XLINE",function:"Construction Line — Infinite line",description:"Press XLINE + Enter to draw an infinite construction line through two points."},
  {id:"ac-191",shortcut:"BHATCH",function:"Batch Hatch — Boundary hatch",description:"Press BHATCH + Enter to fill an enclosed area with a hatch pattern."},
  {id:"ac-192",shortcut:"DDEDIT",function:"Edit Text — Modify text content",description:"Press DDEDIT + Enter to edit the content of text and dimension text."},
  {id:"ac-193",shortcut:"STYLE",function:"Text Style — Manage text styles",description:"Press STYLE + Enter to create and modify named text styles."},
  {id:"ac-194",shortcut:"LINETYPE",function:"Linetype Manager",description:"Press LINETYPE + Enter to load, set, and manage linetypes."},
  {id:"ac-195",shortcut:"LWEIGHT",function:"Lineweight Settings",description:"Press LWEIGHT + Enter to set display and plot lineweight settings."},
  {id:"ac-196",shortcut:"COLOR",function:"Color — Set entity color",description:"Press COLOR + Enter to set the current color for new objects."},
  {id:"ac-197",shortcut:"DDPTYPE",function:"Point Style — Set point display",description:"Press DDPTYPE + Enter to set the display style and size of point objects."},
].map(e => ({...e, category: "autocad"}));

const autocadFinal = [...acExisting, ...acNew];
fs.writeFileSync(path.join(dataDir, 'autocad.json'), JSON.stringify(autocadFinal, null, 2) + '\n');
console.log(`AutoCAD: ${autocadFinal.length} entries`);

// === EXCEL: Clean duplicates + add new ===
const xlExisting = JSON.parse(fs.readFileSync(path.join(dataDir, 'excel.json'), 'utf8'));
// Deduplicate by shortcut
const xlSeen = new Set();
const xlClean = xlExisting.filter(e => {
  if (xlSeen.has(e.shortcut)) return false;
  xlSeen.add(e.shortcut);
  return true;
});

const xlNew = [
  {id:"xl-200",shortcut:"Ctrl + Shift + Enter",function:"Enter array formula"},
  {id:"xl-201",shortcut:"Alt + H + B",function:"Add borders menu"},
  {id:"xl-202",shortcut:"Alt + H + H",function:"Fill color picker"},
  {id:"xl-203",shortcut:"Alt + H + F + C",function:"Font color picker"},
  {id:"xl-204",shortcut:"Alt + H + A + C",function:"Center align cell"},
  {id:"xl-205",shortcut:"Alt + H + W",function:"Wrap text toggle"},
  {id:"xl-206",shortcut:"Alt + H + M + M",function:"Merge and center cells"},
  {id:"xl-207",shortcut:"Alt + H + O + I",function:"Auto-fit column width"},
  {id:"xl-208",shortcut:"Alt + H + O + A",function:"Auto-fit row height"},
  {id:"xl-209",shortcut:"Alt + N + V",function:"Insert Pivot Table"},
  {id:"xl-210",shortcut:"Alt + N + C",function:"Insert Column Chart"},
  {id:"xl-211",shortcut:"Alt + N + N",function:"Insert Line Chart"},
  {id:"xl-212",shortcut:"Alt + N + Q",function:"Insert Pie Chart"},
  {id:"xl-213",shortcut:"Alt + A + T",function:"Data Tools menu"},
  {id:"xl-214",shortcut:"Alt + A + V + V",function:"Data Validation dialog"},
  {id:"xl-215",shortcut:"Alt + A + E",function:"Flash Fill"},
  {id:"xl-216",shortcut:"Alt + A + M",function:"Remove Duplicates"},
  {id:"xl-217",shortcut:"Alt + A + S + S",function:"Sort ascending"},
  {id:"xl-218",shortcut:"Alt + A + S + O",function:"Sort descending"},
  {id:"xl-219",shortcut:"Alt + A + C",function:"Clear all filters"},
  {id:"xl-220",shortcut:"Alt + W + F + F",function:"Freeze top row panes"},
  {id:"xl-221",shortcut:"Alt + W + S",function:"Split window panes"},
  {id:"xl-222",shortcut:"Alt + W + N",function:"New window of workbook"},
  {id:"xl-223",shortcut:"Alt + P + S + P",function:"Set print area"},
  {id:"xl-224",shortcut:"Alt + P + B",function:"Insert page break"},
  {id:"xl-225",shortcut:"Alt + P + M",function:"Page margins settings"},
  {id:"xl-226",shortcut:"Alt + P + O",function:"Page orientation"},
  {id:"xl-227",shortcut:"Alt + M + F",function:"Insert Function wizard"},
  {id:"xl-228",shortcut:"Alt + M + U",function:"AutoSum menu"},
  {id:"xl-229",shortcut:"Alt + M + R",function:"Recently used functions"},
  {id:"xl-230",shortcut:"Alt + M + T",function:"Financial functions"},
  {id:"xl-231",shortcut:"Alt + M + O",function:"Logical functions"},
  {id:"xl-232",shortcut:"Alt + M + E",function:"Text functions"},
  {id:"xl-233",shortcut:"Alt + M + D",function:"Date & Time functions"},
  {id:"xl-234",shortcut:"Alt + M + Q",function:"Lookup & Reference functions"},
  {id:"xl-235",shortcut:"Ctrl + Shift + End",function:"Select to last used cell"},
  {id:"xl-236",shortcut:"Ctrl + Shift + Home",function:"Select to cell A1"},
  {id:"xl-237",shortcut:"Ctrl + G",function:"Go To dialog"},
  {id:"xl-238",shortcut:"Ctrl + Shift + G",function:"Go To Special dialog"},
  {id:"xl-239",shortcut:"Ctrl + W",function:"Close current workbook"},
  {id:"xl-240",shortcut:"Ctrl + F4",function:"Close workbook window"},
  {id:"xl-241",shortcut:"Shift + F2",function:"Insert/edit cell comment"},
  {id:"xl-242",shortcut:"Ctrl + Shift + F3",function:"Create names from selection"},
  {id:"xl-243",shortcut:"Ctrl + Shift + J",function:"Consolidate data"},
  {id:"xl-244",shortcut:"Alt + D + P",function:"PivotTable wizard"},
  {id:"xl-245",shortcut:"Alt + D + G + G",function:"Group selected items"},
  {id:"xl-246",shortcut:"Alt + D + G + U",function:"Ungroup selected items"},
  {id:"xl-247",shortcut:"Ctrl + 8",function:"Toggle outline symbols"},
  {id:"xl-248",shortcut:"Alt + Shift + Right",function:"Group rows/columns"},
  {id:"xl-249",shortcut:"Alt + Shift + Left",function:"Ungroup rows/columns"},
  {id:"xl-250",shortcut:"Ctrl + Shift + F1",function:"Toggle task pane"},
  {id:"xl-251",shortcut:"Ctrl + Alt + F9",function:"Full recalculate all"},
  {id:"xl-252",shortcut:"Ctrl + Alt + Shift + F9",function:"Recheck dependent formulas"},
  {id:"xl-253",shortcut:"Shift + F10",function:"Show context menu"},
  {id:"xl-254",shortcut:"Alt + F8",function:"Open Macro dialog"},
].filter(e => !xlSeen.has(e.shortcut)).map(e => ({...e, category: "excel"}));

const excelFinal = [...xlClean, ...xlNew];
fs.writeFileSync(path.join(dataDir, 'excel.json'), JSON.stringify(excelFinal, null, 2) + '\n');
console.log(`Excel: ${excelFinal.length} entries`);

// === WORD: Add 50+ new entries ===
const wordExisting = JSON.parse(fs.readFileSync(path.join(dataDir, 'word.json'), 'utf8'));
const wdSeen = new Set(wordExisting.map(e => e.shortcut));

const wdNew = [
  {id:"word-041",shortcut:"Ctrl + Shift + S",function:"Apply Styles pane"},
  {id:"word-042",shortcut:"Ctrl + Shift + K",function:"Small capitals"},
  {id:"word-043",shortcut:"Ctrl + Shift + A",function:"All capitals"},
  {id:"word-044",shortcut:"Ctrl + Shift + W",function:"Underline words only"},
  {id:"word-045",shortcut:"Ctrl + Shift + D",function:"Double underline"},
  {id:"word-046",shortcut:"Ctrl + Shift + H",function:"Hidden text"},
  {id:"word-047",shortcut:"Ctrl + D",function:"Font dialog box"},
  {id:"word-048",shortcut:"Ctrl + Shift + Q",function:"Symbol font"},
  {id:"word-049",shortcut:"Ctrl + =",function:"Subscript toggle"},
  {id:"word-050",shortcut:"Ctrl + Shift + =",function:"Superscript toggle"},
  {id:"word-051",shortcut:"Ctrl + Alt + 1",function:"Heading 1 style"},
  {id:"word-052",shortcut:"Ctrl + Alt + 2",function:"Heading 2 style"},
  {id:"word-053",shortcut:"Ctrl + Alt + 3",function:"Heading 3 style"},
  {id:"word-054",shortcut:"Alt + Shift + D",function:"Insert date field"},
  {id:"word-055",shortcut:"Alt + Shift + T",function:"Insert time field"},
  {id:"word-056",shortcut:"Alt + Shift + P",function:"Insert page number"},
  {id:"word-057",shortcut:"Ctrl + Shift + Enter",function:"Column break"},
  {id:"word-058",shortcut:"Shift + Enter",function:"Line break"},
  {id:"word-059",shortcut:"Ctrl + Shift + Space",function:"Non-breaking space"},
  {id:"word-060",shortcut:"Ctrl + Shift + -",function:"Non-breaking hyphen"},
  {id:"word-061",shortcut:"Ctrl + Alt + M",function:"Insert comment"},
  {id:"word-062",shortcut:"Ctrl + Shift + E",function:"Track Changes toggle"},
  {id:"word-063",shortcut:"Alt + Shift + C",function:"Close Review pane"},
  {id:"word-064",shortcut:"Alt + Shift + N",function:"Next revision"},
  {id:"word-065",shortcut:"Alt + Shift + A",function:"Accept all changes"},
  {id:"word-066",shortcut:"Alt + Ctrl + Home",function:"Browse document start"},
  {id:"word-067",shortcut:"Ctrl + Alt + Page Down",function:"Next browse point"},
  {id:"word-068",shortcut:"Ctrl + Alt + Page Up",function:"Previous browse point"},
  {id:"word-069",shortcut:"F5",function:"Go To / Find & Replace"},
  {id:"word-070",shortcut:"Shift + F5",function:"Return to last edit point"},
  {id:"word-071",shortcut:"Alt + Ctrl + Z",function:"Cycle last 4 edit points"},
  {id:"word-072",shortcut:"F8",function:"Extend selection mode"},
  {id:"word-073",shortcut:"Shift + F8",function:"Shrink selection"},
  {id:"word-074",shortcut:"Ctrl + Shift + F5",function:"Insert bookmark"},
  {id:"word-075",shortcut:"Alt + F9",function:"Toggle field codes"},
  {id:"word-076",shortcut:"F9",function:"Update selected field"},
  {id:"word-077",shortcut:"Ctrl + F9",function:"Insert empty field"},
  {id:"word-078",shortcut:"Ctrl + Shift + F9",function:"Unlink field"},
  {id:"word-079",shortcut:"F11",function:"Next field"},
  {id:"word-080",shortcut:"Shift + F11",function:"Previous field"},
  {id:"word-081",shortcut:"Alt + F5",function:"Restore window size"},
  {id:"word-082",shortcut:"Ctrl + Alt + S",function:"Split document window"},
  {id:"word-083",shortcut:"Alt + Shift + F7",function:"Thesaurus"},
  {id:"word-084",shortcut:"Ctrl + Shift + 8",function:"Show/hide formatting marks"},
  {id:"word-085",shortcut:"Alt + Shift + O",function:"Mark Table of Contents"},
  {id:"word-086",shortcut:"Alt + Shift + I",function:"Mark citation"},
  {id:"word-087",shortcut:"Alt + Shift + X",function:"Mark index entry"},
  {id:"word-088",shortcut:"Alt + Ctrl + F",function:"Insert footnote"},
  {id:"word-089",shortcut:"Alt + Ctrl + D",function:"Insert endnote"},
  {id:"word-090",shortcut:"Ctrl + Alt + V",function:"Paste Special dialog"},
  {id:"word-091",shortcut:"Alt + Shift + K",function:"Mail merge preview"},
  {id:"word-092",shortcut:"Alt + Shift + M",function:"Insert merge field"},
  {id:"word-093",shortcut:"Ctrl + F2",function:"Print preview"},
].filter(e => !wdSeen.has(e.shortcut)).map(e => ({...e, category: "word"}));

const wordFinal = [...wordExisting, ...wdNew];
fs.writeFileSync(path.join(dataDir, 'word.json'), JSON.stringify(wordFinal, null, 2) + '\n');
console.log(`Word: ${wordFinal.length} entries`);

// === TALLY: Add 50+ new entries ===
const talExisting = JSON.parse(fs.readFileSync(path.join(dataDir, 'tally.json'), 'utf8'));
const talSeen = new Set(talExisting.map(e => e.shortcut));

const talNew = [
  {id:"tal-051",shortcut:"Ctrl + Enter",function:"Accept and save voucher"},
  {id:"tal-052",shortcut:"Ctrl + F2",function:"Change voucher mode"},
  {id:"tal-053",shortcut:"Alt + G",function:"Go to Gateway of Tally"},
  {id:"tal-054",shortcut:"Alt + K",function:"Create stock item"},
  {id:"tal-055",shortcut:"Alt + H",function:"Change voucher type"},
  {id:"tal-056",shortcut:"Alt + J",function:"Statutory adjustment"},
  {id:"tal-057",shortcut:"Alt + S",function:"Stock summary"},
  {id:"tal-058",shortcut:"Alt + I",function:"Insert line in voucher"},
  {id:"tal-059",shortcut:"Ctrl + R",function:"Repeat narration"},
  {id:"tal-060",shortcut:"Ctrl + T",function:"Stock category summary"},
  {id:"tal-061",shortcut:"Ctrl + F5",function:"Payroll voucher"},
  {id:"tal-062",shortcut:"Ctrl + F6",function:"Rejection In note"},
  {id:"tal-063",shortcut:"Ctrl + F7",function:"Rejection Out note"},
  {id:"tal-064",shortcut:"Ctrl + F4",function:"Payroll auto journal"},
  {id:"tal-065",shortcut:"Ctrl + F10",function:"Memorandum voucher"},
  {id:"tal-066",shortcut:"Ctrl + Alt + F1",function:"Day Book report"},
  {id:"tal-067",shortcut:"F1 (at Gateway)",function:"Select accounts info"},
  {id:"tal-068",shortcut:"Alt + F12 (reports)",function:"Range filter in report"},
  {id:"tal-069",shortcut:"Ctrl + Alt + I",function:"Statutory info settings"},
  {id:"tal-070",shortcut:"Ctrl + Alt + B",function:"Check balance sheet"},
  {id:"tal-071",shortcut:"Ctrl + Alt + R",function:"View registers"},
  {id:"tal-072",shortcut:"Ctrl + Shift + D",function:"Delete company data"},
  {id:"tal-073",shortcut:"Alt + V",function:"GST returns view"},
  {id:"tal-074",shortcut:"Ctrl + Alt + G",function:"GSTR-1 report"},
  {id:"tal-075",shortcut:"Ctrl + Alt + H",function:"GSTR-2 report"},
  {id:"tal-076",shortcut:"Ctrl + Alt + J",function:"GSTR-3B report"},
  {id:"tal-077",shortcut:"Ctrl + E",function:"Export report to Excel"},
  {id:"tal-078",shortcut:"Alt + F3 (Company)",function:"Shut company"},
  {id:"tal-079",shortcut:"Ctrl + Alt + C",function:"Create company"},
  {id:"tal-080",shortcut:"Ctrl + K",function:"Create cost centre"},
  {id:"tal-081",shortcut:"Ctrl + Alt + V",function:"Alter voucher type"},
  {id:"tal-082",shortcut:"Alt + S (voucher)",function:"Select stock item"},
  {id:"tal-083",shortcut:"Ctrl + Shift + F1",function:"Cash Flow statement"},
  {id:"tal-084",shortcut:"Ctrl + Shift + F5",function:"Fund Flow statement"},
  {id:"tal-085",shortcut:"Ctrl + Shift + B",function:"Trial Balance"},
  {id:"tal-086",shortcut:"Ctrl + Shift + P",function:"Profit & Loss account"},
  {id:"tal-087",shortcut:"Alt + N",function:"Toggle auto-numbering"},
  {id:"tal-088",shortcut:"Ctrl + Shift + Enter",function:"Accept blank details"},
  {id:"tal-089",shortcut:"Page Up",function:"Previous voucher"},
  {id:"tal-090",shortcut:"Page Down",function:"Next voucher"},
  {id:"tal-091",shortcut:"Home",function:"First voucher in list"},
  {id:"tal-092",shortcut:"End",function:"Last voucher in list"},
  {id:"tal-093",shortcut:"Ctrl + Alt + F2",function:"Change period scope"},
  {id:"tal-094",shortcut:"Ctrl + Shift + F8",function:"Optional voucher"},
  {id:"tal-095",shortcut:"Alt + G + S",function:"Stock summary report"},
  {id:"tal-096",shortcut:"Alt + G + P",function:"Profit & Loss shortcut"},
  {id:"tal-097",shortcut:"Alt + G + B",function:"Balance Sheet shortcut"},
  {id:"tal-098",shortcut:"Alt + G + R",function:"All reports menu"},
  {id:"tal-099",shortcut:"Alt + G + D",function:"Day Book access"},
  {id:"tal-100",shortcut:"Alt + G + I",function:"Inventory reports"},
  {id:"tal-101",shortcut:"Ctrl + U",function:"Undo changes in voucher"},
  {id:"tal-102",shortcut:"Ctrl + Shift + A",function:"Alter GST details"},
  {id:"tal-103",shortcut:"Ctrl + Alt + E",function:"E-Way Bill report"},
].filter(e => !talSeen.has(e.shortcut)).map(e => ({...e, category: "tally"}));

const tallyFinal = [...talExisting, ...talNew];
fs.writeFileSync(path.join(dataDir, 'tally.json'), JSON.stringify(tallyFinal, null, 2) + '\n');
console.log(`Tally: ${tallyFinal.length} entries`);

console.log('Done! All JSON files updated.');
