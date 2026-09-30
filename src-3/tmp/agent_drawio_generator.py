#!/usr/bin/env python3
"""Generate two uncompressed diagrams.net files for Global Express.

The generated files are deliberately kept in ``src-3/tmp``.  They are review
artifacts for the main task and are not the final deliverables.
"""

from __future__ import annotations

from pathlib import Path
import xml.etree.ElementTree as ET


OUT_DIR = Path(__file__).resolve().parent


class DrawioDiagram:
    """Small helper for an uncompressed diagrams.net document."""

    def __init__(self, *, diagram_id: str, name: str, width: int, height: int) -> None:
        self.mxfile = ET.Element(
            "mxfile",
            {
                "host": "app.diagrams.net",
                "agent": "Codex Global Express generator",
                "version": "24.7.17",
                "type": "device",
                "compressed": "false",
            },
        )
        diagram = ET.SubElement(
            self.mxfile, "diagram", {"id": diagram_id, "name": name}
        )
        self.model = ET.SubElement(
            diagram,
            "mxGraphModel",
            {
                "dx": "1600",
                "dy": "1000",
                "grid": "1",
                "gridSize": "10",
                "guides": "1",
                "tooltips": "1",
                "connect": "1",
                "arrows": "1",
                "fold": "1",
                "page": "1",
                "pageScale": "1",
                "pageWidth": str(width),
                "pageHeight": str(height),
                "math": "0",
                "shadow": "0",
                "background": "#F8FAFC",
            },
        )
        self.root = ET.SubElement(self.model, "root")
        ET.SubElement(self.root, "mxCell", {"id": "0"})
        ET.SubElement(self.root, "mxCell", {"id": "1", "parent": "0"})

    def vertex(
        self,
        cell_id: str,
        value: str,
        style: str,
        x: int,
        y: int,
        width: int,
        height: int,
        *,
        parent: str = "1",
    ) -> ET.Element:
        cell = ET.SubElement(
            self.root,
            "mxCell",
            {
                "id": cell_id,
                "value": value,
                "style": style,
                "vertex": "1",
                "parent": parent,
            },
        )
        ET.SubElement(
            cell,
            "mxGeometry",
            {
                "x": str(x),
                "y": str(y),
                "width": str(width),
                "height": str(height),
                "as": "geometry",
            },
        )
        return cell

    def edge(
        self,
        cell_id: str,
        source: str,
        target: str,
        *,
        value: str = "",
        style: str,
        parent: str = "1",
    ) -> ET.Element:
        cell = ET.SubElement(
            self.root,
            "mxCell",
            {
                "id": cell_id,
                "value": value,
                "style": style,
                "edge": "1",
                "parent": parent,
                "source": source,
                "target": target,
            },
        )
        ET.SubElement(cell, "mxGeometry", {"relative": "1", "as": "geometry"})
        return cell

    def edge_end_label(
        self, edge_id: str, suffix: str, value: str, position: float
    ) -> None:
        cell = ET.SubElement(
            self.root,
            "mxCell",
            {
                "id": f"{edge_id}_{suffix}",
                "value": value,
                "style": (
                    "edgeLabel;resizable=0;html=1;align=center;verticalAlign=middle;"
                    "fontFamily=Segoe UI;fontSize=13;fontStyle=1;fontColor=#7F1D1D;"
                    "labelBackgroundColor=#FFFFFF;labelBorderColor=#CBD5E1;rounded=1;"
                ),
                "connectable": "0",
                "vertex": "1",
                "parent": edge_id,
            },
        )
        geometry = ET.SubElement(
            cell,
            "mxGeometry",
            {"x": str(position), "relative": "1", "as": "geometry"},
        )
        ET.SubElement(geometry, "mxPoint", {"y": "-11", "as": "offset"})

    def write(self, path: Path) -> None:
        tree = ET.ElementTree(self.mxfile)
        ET.indent(tree, space="  ")
        tree.write(path, encoding="utf-8", xml_declaration=True)


ENTITY_STYLE = (
    "rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#2563EB;"
    "strokeWidth=2;shadow=1;arcSize=7;align=left;verticalAlign=top;spacing=0;"
    "fontFamily=Segoe UI;fontSize=11;fontColor=#0F172A;"
)
ASSOCIATIVE_STYLE = ENTITY_STYLE.replace("#2563EB", "#7C3AED").replace(
    "fillColor=#FFFFFF", "fillColor=#FAF5FF"
)
SUBTYPE_STYLE = ENTITY_STYLE.replace("#2563EB", "#0F766E").replace(
    "fillColor=#FFFFFF", "fillColor=#F0FDFA"
)
REL_STYLE = (
    "shape=rhombus;whiteSpace=wrap;html=1;fillColor=#FEF3C7;strokeColor=#D97706;"
    "strokeWidth=2;shadow=1;fontFamily=Segoe UI;fontSize=11;fontStyle=1;"
    "fontColor=#78350F;align=center;verticalAlign=middle;"
)
ER_EDGE_STYLE = (
    "edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;"
    "html=1;strokeColor=#334155;strokeWidth=1.8;endArrow=none;"
    "fontFamily=Segoe UI;fontSize=11;fontStyle=1;fontColor=#0F172A;"
    "labelBackgroundColor=#FFFFFF;"
)


def entity_html(name: str, attributes: list[tuple[str, str]]) -> str:
    """Render a compact conceptual entity card.

    Attribute markers: ``PK`` underlines the candidate/primary identifier,
    ``+`` highlights one of the three student-added attributes, and ``D`` marks
    the specialization discriminator.
    """
    rows: list[str] = []
    for attr, marker in attributes:
        if marker == "PK":
            shown = f"<u><b>{attr}</b></u> <span style='color:#B45309'>(cheie)</span>"
        elif marker == "+":
            shown = (
                f"<b style='color:#166534'>{attr}</b> "
                "<span style='color:#16A34A;font-weight:bold'>[+]</span>"
            )
        elif marker == "D":
            shown = f"<b>{attr}</b> <span style='color:#0F766E'>(discriminator)</span>"
        else:
            shown = attr
        rows.append(f"<div style='padding:2px 9px;border-top:1px solid #E2E8F0'>{shown}</div>")
    return (
        "<div style='font-family:Segoe UI,Tahoma,sans-serif'>"
        f"<div style='background:#1D4ED8;color:#FFFFFF;padding:7px 9px;font-size:13px'>&lt;&lt;entitate&gt;&gt; <b>{name}</b></div>"
        + "".join(rows)
        + "</div>"
    )


def add_er_relation(
    doc: DrawioDiagram,
    relation_id: str,
    relation_name: str,
    x: int,
    y: int,
    width: int,
    source: str,
    target: str,
    source_cardinality: str,
    target_cardinality: str,
) -> None:
    doc.vertex(
        relation_id,
        f"<b>{relation_name}</b>",
        REL_STYLE,
        x,
        y,
        width,
        66,
    )
    doc.edge(
        f"{relation_id}_left",
        source,
        relation_id,
        value=source_cardinality,
        style=ER_EDGE_STYLE,
    )
    doc.edge(
        f"{relation_id}_right",
        relation_id,
        target,
        value=target_cardinality,
        style=ER_EDGE_STYLE,
    )


def build_conceptual() -> Path:
    doc = DrawioDiagram(
        diagram_id="global-express-conceptual",
        name="Global Express - Model conceptual ER/EER",
        width=2150,
        height=1300,
    )
    doc.vertex(
        "title",
        (
            "<div style='font-family:Segoe UI,Tahoma,sans-serif;text-align:left'>"
            "<b style='font-size:19px'>GLOBAL EXPRESS — Model conceptual ER/EER</b><br/>"
            "<span style='font-size:11px;color:#CBD5E1'>Entități, asocieri, limite de participare și specializare totală disjunctă</span>"
            "</div>"
        ),
        "rounded=1;whiteSpace=wrap;html=1;fillColor=#0F172A;strokeColor=#020617;"
        "fontColor=#FFFFFF;shadow=1;arcSize=5;spacingLeft=18;align=left;verticalAlign=middle;",
        35,
        25,
        2080,
        70,
    )

    entities = {
        "client": (
            "CLIENT",
            [
                ("id_client", "PK"),
                ("denumire_sau_nume", ""),
                ("strada, numar", ""),
                ("oras, tara", ""),
                ("telefon", ""),
            ],
            (40, 210, 245, 190),
            ENTITY_STYLE,
        ),
        "colet": (
            "COLET",
            [
                ("tracking_id", "PK"),
                ("greutate_kg", ""),
                ("descriere_vama", ""),
                ("valoare_declarata", ""),
                ("data_preluare", ""),
                ("volum_cm3", "+"),
                ("status_curent", "+"),
            ],
            (570, 190, 270, 245),
            ENTITY_STYLE,
        ),
        "ruta": (
            "RUTA",
            [("id_ruta", "PK"), ("nume_ruta (unic)", "")],
            (1090, 210, 230, 115),
            ENTITY_STYLE,
        ),
        "segment": (
            "SEGMENT_DRUM",
            [
                ("id_segment", "PK"),
                ("punct_plecare", ""),
                ("punct_sosire", ""),
                ("distanta_km", ""),
            ],
            (1680, 190, 265, 165),
            ENTITY_STYLE,
        ),
        "scanare": (
            "SCANARE_EVENIMENT",
            [
                ("id_scanare", "PK"),
                ("marca_temporala", ""),
                ("tip_eveniment", ""),
                ("flag_deviere_ruta", "+"),
            ],
            (510, 735, 315, 170),
            ASSOCIATIVE_STYLE,
        ),
        "angajat": (
            "ANGAJAT",
            [("cod_personal", "PK"), ("nume", ""), ("prenume", "")],
            (1080, 760, 250, 140),
            ENTITY_STYLE,
        ),
        "locatie": (
            "LOCATIE_TRANZIT",
            [
                ("id_locatie", "PK"),
                ("denumire_oficiala", ""),
                ("localitate", ""),
                ("tip_locatie", "D"),
            ],
            (1600, 500, 290, 170),
            ENTITY_STYLE,
        ),
        "hub": (
            "HUB_AEROPORTUAR",
            [("id_locatie", "PK"), ("cod_iata (unic)", "")],
            (1290, 1025, 250, 115),
            SUBTYPE_STYLE,
        ),
        "depozit": (
            "DEPOZIT_REGIONAL",
            [("id_locatie", "PK"), ("capacitate_colete", "")],
            (1580, 1025, 250, 115),
            SUBTYPE_STYLE,
        ),
        "centru": (
            "CENTRU_SORTARE",
            [("id_locatie", "PK"), ("capacitate_sortare_ora", "")],
            (1860, 1025, 250, 115),
            SUBTYPE_STYLE,
        ),
    }
    for cell_id, (name, attrs, geometry, style) in entities.items():
        x, y, width, height = geometry
        doc.vertex(cell_id, entity_html(name, attrs), style, x, y, width, height)

    add_er_relation(doc, "expediaza", "Expediază", 355, 145, 135, "client", "colet", "(0,N)", "(1,1)")
    add_er_relation(doc, "primeste", "Primește", 355, 365, 135, "client", "colet", "(0,N)", "(1,1)")
    add_er_relation(doc, "atribuire", "Este atribuită", 905, 245, 140, "colet", "ruta", "(1,1)", "(0,N)")
    add_er_relation(doc, "compunere", "Compusă din", 1435, 235, 145, "ruta", "segment", "(1,N)", "(0,N)")
    add_er_relation(doc, "are_scanari", "Are", 625, 545, 120, "colet", "scanare", "(1,N)", "(1,1)")
    add_er_relation(doc, "efectueaza", "Efectuează", 875, 785, 130, "scanare", "angajat", "(1,1)", "(0,N)")
    add_er_relation(doc, "inregistreaza", "Înregistrează", 1285, 615, 145, "scanare", "locatie", "(1,1)", "(0,N)")

    doc.vertex(
        "nr_ordine",
        "<b>nr_ordine</b><br/><span style='font-size:10px;color:#64748B'>atribut al asocierii</span>",
        "ellipse;whiteSpace=wrap;html=1;fillColor=#FFFBEB;strokeColor=#D97706;"
        "strokeWidth=1.5;fontFamily=Segoe UI;fontSize=11;fontColor=#78350F;",
        1450,
        365,
        125,
        58,
    )
    doc.edge(
        "nr_ordine_edge",
        "compunere",
        "nr_ordine",
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;html=1;strokeColor=#D97706;strokeWidth=1.3;endArrow=none;dashed=1;",
    )

    doc.vertex(
        "specializare",
        (
            "<div style='text-align:center'><b>{d}</b><br/>"
            "<span style='font-size:9px'>TOTALĂ</span></div>"
        ),
        "shape=triangle;direction=north;whiteSpace=wrap;html=1;fillColor=#CCFBF1;"
        "strokeColor=#0F766E;strokeWidth=2;fontFamily=Segoe UI;fontSize=12;fontColor=#134E4A;",
        1695,
        790,
        95,
        75,
    )
    doc.edge(
        "locatie_specializare",
        "locatie",
        "specializare",
        style=ER_EDGE_STYLE + "strokeColor=#0F766E;strokeWidth=3;",
    )
    for subtype in ("hub", "depozit", "centru"):
        doc.edge(
            f"specializare_{subtype}",
            "specializare",
            subtype,
            style=ER_EDGE_STYLE + "strokeColor=#0F766E;strokeWidth=1.8;",
        )

    doc.vertex(
        "legend",
        (
            "<div style='font-family:Segoe UI,Tahoma,sans-serif'>"
            "<b>Legendă:</b> <u><b>atribut</b></u> = cheie; "
            "<b style='color:#16A34A'>[+]</b> = atribut adăugat; "
            "<span style='color:#7C3AED'>mov</span> = entitate asociativă; "
            "<span style='color:#0F766E'>{d}, totală</span> = subclase disjuncte și acoperire completă. "
            "RUTA—SEGMENT_DRUM este M:N, iar <b>nr_ordine</b> păstrează succesiunea."
            "</div>"
        ),
        "rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#CBD5E1;"
        "fontColor=#334155;fontFamily=Segoe UI;fontSize=11;align=left;verticalAlign=middle;spacingLeft=12;",
        40,
        1190,
        2070,
        55,
    )

    output = OUT_DIR / "agent_Global_Express_ER_EER.drawio"
    doc.write(output)
    return output


ACCESS_TABLE_STYLE = (
    "swimlane;fontStyle=1;align=left;verticalAlign=top;childLayout=stackLayout;"
    "horizontal=1;startSize=30;horizontalStack=0;resizeParent=0;resizeParentMax=0;"
    "resizeLast=0;collapsible=1;marginBottom=0;html=1;whiteSpace=wrap;"
    "fillColor=#A4373A;strokeColor=#5C1518;fontColor=#FFFFFF;fontSize=12;"
    "fontFamily=Segoe UI,Tahoma,sans-serif;rounded=1;arcSize=4;shadow=1;spacingLeft=8;"
)
ACCESS_EDGE_STYLE = (
    "edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;"
    "html=1;strokeColor=#852225;strokeWidth=2.1;endArrow=none;"
)


def access_field_html(field_name: str, data_type: str, marker: str) -> str:
    if marker == "PK":
        badge = "<span style='color:#B45309;font-weight:bold'>PK</span>"
    elif marker == "FK":
        badge = "<span style='color:#2563EB;font-weight:bold'>FK</span>"
    elif marker == "PK/FK":
        badge = "<span style='color:#7C3AED;font-weight:bold'>PK/FK</span>"
    else:
        badge = "<span style='color:transparent'>--</span>"
    weight = "font-weight:bold;" if marker else ""
    return (
        "<table style='width:100%;font-family:Segoe UI,Tahoma,sans-serif;font-size:10.5px;border-collapse:collapse'>"
        "<tr>"
        f"<td style='width:48px;text-align:left;white-space:nowrap'>{badge}</td>"
        f"<td style='text-align:left;white-space:nowrap;{weight}color:#0F172A'>{field_name}</td>"
        f"<td style='text-align:right;color:#64748B;font-size:9.5px;white-space:nowrap;padding-right:4px'>{data_type}</td>"
        "</tr></table>"
    )


def add_access_table(
    doc: DrawioDiagram,
    table_id: str,
    table_name: str,
    x: int,
    y: int,
    width: int,
    fields: list[tuple[str, str, str]],
) -> dict[str, str]:
    row_height = 25
    height = 30 + row_height * len(fields)
    doc.vertex(
        table_id,
        f"<b>▦ {table_name}</b>",
        ACCESS_TABLE_STYLE,
        x,
        y,
        width,
        height,
    )
    ids: dict[str, str] = {}
    for index, (field_name, data_type, marker) in enumerate(fields):
        row_id = f"{table_id}_{field_name}"
        ids[field_name] = row_id
        fill = "#FFFFFF" if index % 2 == 0 else "#F8FAFC"
        doc.vertex(
            row_id,
            access_field_html(field_name, data_type, marker),
            (
                "text;strokeColor=none;fillColor=" + fill + ";align=left;verticalAlign=middle;"
                "spacingLeft=5;spacingRight=5;overflow=hidden;points=[[0,0.5],[1,0.5]];"
                "portConstraint=eastwest;rotatable=0;whiteSpace=wrap;html=1;"
            ),
            0,
            30 + row_height * index,
            width,
            row_height,
            parent=table_id,
        )
    return ids


def add_access_relationship(
    doc: DrawioDiagram,
    edge_id: str,
    source: str,
    target: str,
    *,
    one_to_one: bool = False,
) -> None:
    doc.edge(edge_id, source, target, style=ACCESS_EDGE_STYLE)
    doc.edge_end_label(edge_id, "one", "1", -0.86)
    doc.edge_end_label(edge_id, "many", "1" if one_to_one else "∞", 0.86)


def build_access() -> Path:
    doc = DrawioDiagram(
        diagram_id="global-express-access",
        name="Global Express - Relații Microsoft Access",
        width=2000,
        height=1200,
    )
    doc.vertex(
        "access_title",
        (
            "<div style='font-family:Segoe UI,Tahoma,sans-serif'>"
            "<b style='font-size:17px'>Microsoft Access — Instrumente bază de date / Relații</b><br/>"
            "<span style='font-size:11px;color:#FECACA'>GLOBAL EXPRESS • toate legăturile au integritatea referențială activată</span>"
            "</div>"
        ),
        "rounded=0;whiteSpace=wrap;html=1;fillColor=#852225;strokeColor=#5C1518;"
        "fontColor=#FFFFFF;shadow=1;align=left;verticalAlign=middle;spacingLeft=18;",
        30,
        20,
        1940,
        58,
    )
    doc.vertex(
        "access_ribbon",
        (
            "<span style='font-family:Segoe UI,Tahoma,sans-serif;color:#334155'>"
            "<b>Relații</b>&nbsp;&nbsp;&nbsp; Afișare tabel&nbsp;&nbsp; | &nbsp;&nbsp;Editare relații&nbsp;&nbsp; | &nbsp;&nbsp;"
            "Raport relații&nbsp;&nbsp;&nbsp;&nbsp; <span style='color:#852225'>☑ Impunere integritate referențială</span>"
            "</span>"
        ),
        "rounded=0;whiteSpace=wrap;html=1;fillColor=#E2E8F0;strokeColor=#CBD5E1;"
        "align=left;verticalAlign=middle;spacingLeft=18;fontSize=11;",
        30,
        78,
        1940,
        42,
    )

    tables: dict[str, dict[str, str]] = {}
    tables["clienti"] = add_access_table(
        doc,
        "tbl_clienti",
        "CLIENTI",
        45,
        180,
        330,
        [
            ("id_client", "Număr automat", "PK"),
            ("denumire_sau_nume", "Text scurt (150)", ""),
            ("strada", "Text scurt (100)", ""),
            ("numar", "Text scurt (20)", ""),
            ("oras", "Text scurt (60)", ""),
            ("tara", "Text scurt (60)", ""),
            ("telefon", "Text scurt (25)", ""),
        ],
    )
    tables["colete"] = add_access_table(
        doc,
        "tbl_colete",
        "COLETE",
        470,
        150,
        390,
        [
            ("tracking_id", "Text scurt (30)", "PK"),
            ("greutate_kg", "Număr - Dublă", ""),
            ("descriere_vama", "Text scurt (255)", ""),
            ("valoare_declarata", "Monedă", ""),
            ("data_preluare", "Dată/Ora", ""),
            ("volum_cm3", "Număr - Dublă", ""),
            ("status_curent", "Text scurt (20)", ""),
            ("id_expeditor", "Număr - Întreg lung", "FK"),
            ("id_destinatar", "Număr - Întreg lung", "FK"),
            ("id_ruta", "Număr - Întreg lung", "FK"),
        ],
    )
    tables["rute"] = add_access_table(
        doc,
        "tbl_rute",
        "RUTE",
        1015,
        160,
        320,
        [
            ("id_ruta", "Număr automat", "PK"),
            ("nume_ruta", "Text scurt (100)", ""),
        ],
    )
    tables["rute_segmente"] = add_access_table(
        doc,
        "tbl_rute_segmente",
        "RUTE_SEGMENTE",
        1015,
        330,
        350,
        [
            ("id_ruta", "Număr - Întreg lung", "PK/FK"),
            ("nr_ordine", "Număr - Întreg lung", "PK"),
            ("id_segment", "Număr - Întreg lung", "FK"),
        ],
    )
    tables["segmente"] = add_access_table(
        doc,
        "tbl_segmente",
        "SEGMENTE_DRUM",
        1580,
        315,
        350,
        [
            ("id_segment", "Număr automat", "PK"),
            ("punct_plecare", "Text scurt (100)", ""),
            ("punct_sosire", "Text scurt (100)", ""),
            ("distanta_km", "Număr - Dublă", ""),
        ],
    )
    tables["scanari"] = add_access_table(
        doc,
        "tbl_scanari",
        "SCANARI_EVENIMENTE",
        470,
        720,
        400,
        [
            ("id_scanare", "Număr automat", "PK"),
            ("marca_temporala", "Dată/Ora", ""),
            ("tip_eveniment", "Text scurt (10)", ""),
            ("flag_deviere_ruta", "Da/Nu", ""),
            ("tracking_id", "Text scurt (30)", "FK"),
            ("id_locatie", "Număr - Întreg lung", "FK"),
            ("cod_personal", "Text scurt (20)", "FK"),
        ],
    )
    tables["angajati"] = add_access_table(
        doc,
        "tbl_angajati",
        "ANGAJATI",
        45,
        820,
        330,
        [
            ("cod_personal", "Text scurt (20)", "PK"),
            ("nume", "Text scurt (50)", ""),
            ("prenume", "Text scurt (50)", ""),
        ],
    )
    tables["locatii"] = add_access_table(
        doc,
        "tbl_locatii",
        "LOCATII_TRANZIT",
        1015,
        690,
        350,
        [
            ("id_locatie", "Număr automat", "PK"),
            ("denumire_oficiala", "Text scurt (120)", ""),
            ("localitate", "Text scurt (60)", ""),
            ("tip_locatie", "Text scurt (15)", ""),
        ],
    )
    tables["huburi"] = add_access_table(
        doc,
        "tbl_huburi",
        "HUBURI_AEROPORTUARE",
        1560,
        540,
        370,
        [
            ("id_locatie", "Număr - Întreg lung", "PK/FK"),
            ("cod_iata", "Text scurt (3)", ""),
        ],
    )
    tables["depozite"] = add_access_table(
        doc,
        "tbl_depozite",
        "DEPOZITE_REGIONALE",
        1560,
        700,
        370,
        [
            ("id_locatie", "Număr - Întreg lung", "PK/FK"),
            ("capacitate_colete", "Număr - Întreg lung", ""),
        ],
    )
    tables["centre"] = add_access_table(
        doc,
        "tbl_centre",
        "CENTRE_SORTARE",
        1560,
        860,
        370,
        [
            ("id_locatie", "Număr - Întreg lung", "PK/FK"),
            ("capacitate_sortare_ora", "Număr - Întreg lung", ""),
        ],
    )

    add_access_relationship(doc, "rel_client_exp", tables["clienti"]["id_client"], tables["colete"]["id_expeditor"])
    add_access_relationship(doc, "rel_client_dest", tables["clienti"]["id_client"], tables["colete"]["id_destinatar"])
    add_access_relationship(doc, "rel_ruta_colet", tables["rute"]["id_ruta"], tables["colete"]["id_ruta"])
    add_access_relationship(doc, "rel_ruta_rs", tables["rute"]["id_ruta"], tables["rute_segmente"]["id_ruta"])
    add_access_relationship(doc, "rel_segment_rs", tables["segmente"]["id_segment"], tables["rute_segmente"]["id_segment"])
    add_access_relationship(doc, "rel_colet_scan", tables["colete"]["tracking_id"], tables["scanari"]["tracking_id"])
    add_access_relationship(doc, "rel_angajat_scan", tables["angajati"]["cod_personal"], tables["scanari"]["cod_personal"])
    add_access_relationship(doc, "rel_locatie_scan", tables["locatii"]["id_locatie"], tables["scanari"]["id_locatie"])
    add_access_relationship(doc, "rel_locatie_hub", tables["locatii"]["id_locatie"], tables["huburi"]["id_locatie"], one_to_one=True)
    add_access_relationship(doc, "rel_locatie_depozit", tables["locatii"]["id_locatie"], tables["depozite"]["id_locatie"], one_to_one=True)
    add_access_relationship(doc, "rel_locatie_centru", tables["locatii"]["id_locatie"], tables["centre"]["id_locatie"], one_to_one=True)

    doc.vertex(
        "access_legend",
        (
            "<div style='font-family:Segoe UI,Tahoma,sans-serif'>"
            "<b>Legendă Access:</b> <span style='color:#B45309'><b>PK</b></span> cheie primară; "
            "<span style='color:#2563EB'><b>FK</b></span> cheie străină; "
            "<span style='color:#7C3AED'><b>PK/FK</b></span> cheie partajată; "
            "<b style='color:#852225'>1—∞</b> unu-la-mulți; <b style='color:#852225'>1—1</b> superclasă–subclasă. "
            "Indexuri unice: RUTE.nume_ruta, HUBURI_AEROPORTUARE.cod_iata, "
            "SEGMENTE_DRUM.(punct_plecare, punct_sosire), RUTE_SEGMENTE.(id_ruta, id_segment)."
            "</div>"
        ),
        "rounded=1;whiteSpace=wrap;html=1;fillColor=#FFFFFF;strokeColor=#94A3B8;"
        "fontColor=#334155;fontFamily=Segoe UI;fontSize=10.5;align=left;verticalAlign=middle;spacingLeft=12;",
        45,
        1035,
        1885,
        60,
    )

    output = OUT_DIR / "agent_Global_Express_Access.drawio"
    doc.write(output)
    return output


def main() -> None:
    paths = [build_conceptual(), build_access()]
    for path in paths:
        # Reparse immediately so a malformed generated file fails the command.
        ET.parse(path)
        print(path)


if __name__ == "__main__":
    main()
