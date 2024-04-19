--
-- PostgreSQL database dump
--

-- Dumped from database version 15.4
-- Dumped by pg_dump version 15.4

-- Started on 2024-04-19 08:11:29

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 224 (class 1255 OID 73753)
-- Name: log_login_attempt(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_login_attempt() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (NEW.login_sucessful = true) THEN
        INSERT INTO user_logs (username, login_time, login_sucessful)
        VALUES (NEW.username, current_timestamp, true);
    ELSE
        INSERT INTO user_logs (username, login_time, login_sucessful)
        VALUES (NEW.username, current_timestamp, false);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_login_attempt() OWNER TO postgres;

--
-- TOC entry 225 (class 1255 OID 73754)
-- Name: update_date_mise_a_jour(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_date_mise_a_jour() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.datemiseajour := CURRENT_DATE;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_date_mise_a_jour() OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 73755)
-- Name: useraccounts_last_login_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.useraccounts_last_login_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- inérer login information dans user_logs quand last_login is not null
    IF NEW.last_login IS NOT NULL AND NEW.last_login <> OLD.last_login THEN
        INSERT INTO user_logs (username, id_useraccounts, login_time, login_sucessful)
        VALUES (NEW.username, NEW.id_useraccounts, NEW.last_login, true);
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.useraccounts_last_login_trigger() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 214 (class 1259 OID 73756)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    email character varying(255),
    phone_number character varying(20),
    hire_date date,
    job_id character varying(10),
    salary integer,
    commission_pct double precision,
    manager_id integer,
    department_id integer
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 73761)
-- Name: fournisseurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fournisseurs (
    idfournisseur integer NOT NULL,
    nomfournisseur character varying(255),
    adressefournisseur character varying(255),
    contactfournisseur character varying(20),
    emailfournisseur character varying(50)
);


ALTER TABLE public.fournisseurs OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 73766)
-- Name: medicament_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicament_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.medicament_id_seq OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 73767)
-- Name: medicament; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicament (
    id integer DEFAULT nextval('public.medicament_id_seq'::regclass) NOT NULL,
    nom character varying(255),
    fournisseur character varying(255),
    famille character varying(255),
    forme character varying(255),
    quantitemincommande integer,
    quantitemaxstock integer,
    quantiteenstock integer,
    ordonnance boolean,
    prixvente numeric(10,2),
    prixcommande numeric(10,2),
    seuildecommande numeric(10,2),
    prixunitaireachat double precision,
    datemiseajour date,
    quantitecommande integer,
    quantiterecu integer
);


ALTER TABLE public.medicament OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 73773)
-- Name: receipt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt (
    receipt_id character varying(50) NOT NULL,
    total numeric,
    status character varying(50),
    vendeur character varying(100)
);


ALTER TABLE public.receipt OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 73778)
-- Name: receipt_items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.receipt_items (
    receipt_id character varying(255),
    idmedicament integer,
    nom character varying(255),
    quantite integer,
    total numeric(10,2),
    status character varying(255),
    prix numeric(10,2)
);


ALTER TABLE public.receipt_items OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 73783)
-- Name: sequence_employee; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sequence_employee
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_employee OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 73784)
-- Name: sequence_utilisateur; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sequence_utilisateur
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_utilisateur OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 73785)
-- Name: user_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_logs (
    id_useraccounts integer,
    username character varying(255) NOT NULL,
    login_time timestamp without time zone DEFAULT now(),
    login_sucessful boolean
);


ALTER TABLE public.user_logs OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 73789)
-- Name: useraccounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.useraccounts (
    id_useraccounts bigint DEFAULT nextval('public.sequence_utilisateur'::regclass),
    username character varying(50),
    firstname character varying(50),
    lastname character varying(50),
    mdp_pharm character varying(50),
    last_login timestamp without time zone,
    permission character varying(50) DEFAULT 'User'::character varying,
    status boolean DEFAULT true
);


ALTER TABLE public.useraccounts OWNER TO postgres;

--
-- TOC entry 3361 (class 0 OID 73756)
-- Dependencies: 214
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id) FROM stdin;
554154125	John	Doe	john.doe@email.com	123-456-7890	2023-01-01	IT_PROG	50000	0.1	1	10
962452055	Jane	Smith	jane.smith@email.com	987-654-3210	2023-02-15	SA_REP	60000	0.15	2	20
845445428	Bob	Johnson	bob.johnson@email.com	555-123-4567	2023-03-20	HR_REP	70000	0.2	3	30
\.


--
-- TOC entry 3362 (class 0 OID 73761)
-- Dependencies: 215
-- Data for Name: fournisseurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fournisseurs (idfournisseur, nomfournisseur, adressefournisseur, contactfournisseur, emailfournisseur) FROM stdin;
5	PharmaLink	202 Healing Lane	Charlie Brown	charlie.brown@pharmalink.biz
6	WellnessRx	303 Holistic Road	Eva Green	eva.green@wellnessrx.co
3	HealthCoo	789 Boulevard Wellness	Bob Johnson	bob.johnson@healthco.org
26	Alex	Quatre borne A.5 Avenue des Talipots	54674297	alexpharma@pharma.com
27	Alex	Flic en Flac	54547656	alicia@gmail.com
2	Medisupply	456 Avenue Médicale	54659834	jane.smith@medisupply.net
4	Mediconnect	alice@mediconnect.com	Alice White	alice.white@mediconnect.com
30	Ravi J.	Talipots A5 St Jean Quatre Bornes	54332365	ravi@gmail.com
\.


--
-- TOC entry 3364 (class 0 OID 73767)
-- Dependencies: 217
-- Data for Name: medicament; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.medicament (id, nom, fournisseur, famille, forme, quantitemincommande, quantitemaxstock, quantiteenstock, ordonnance, prixvente, prixcommande, seuildecommande, prixunitaireachat, datemiseajour, quantitecommande, quantiterecu) FROM stdin;
2	Advil 400mg	HealthCo	Anti-inflammatoire	Comprimé	30	150	50	f	10.50	73.00	40.00	6.2	2024-03-19	\N	\N
17	Paracétamol	MediSupply	Comprinés	Rond	100	150	70	f	\N	\N	\N	\N	\N	\N	\N
5	Nurofen 200mg	WellnessRx	Analgésique	Comprimé	40	250	29	f	48.19	51.00	50.00	25	2024-04-19	2	4
3	Panadol 500mg	MediConnect	Analgésique	Suppositoire	20	100	80	t	75.35	78.00	25.00	30	2024-03-25	\N	\N
18	Doliprane	Alex	Comprimé	Rond	50	200	150	f	\N	\N	\N	\N	\N	\N	\N
6	Bepanthen Crème	PharmaGest	Crème	Creme	25	180	90	t	9.80	15.00	60.00	4.7	2024-04-09	\N	\N
20	Lamisil 250 mg	Ravi J.	Terbinafine	Comprimé	10	350	30	t	\N	\N	\N	\N	2024-04-11	\N	\N
19	Paracétamol	Alex	Comprimé	Rond	20	200	5	f	\N	\N	\N	\N	2024-04-11	\N	\N
4	Voltarene 50mg/100Ml	Alex	Comprimé	Flacon	10	300	82	t	67.63	70.00	75.00	55	2024-04-19	0	40
\.


--
-- TOC entry 3365 (class 0 OID 73773)
-- Dependencies: 218
-- Data for Name: receipt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipt (receipt_id, total, status, vendeur) FROM stdin;
RECEIPT_1710400596774	218.33	Payé	\N
RECEIPT_1710400489483	210.61	Payé	\N
RECEIPT_1710399649708	75.25	Payé	ethan
RECEIPT_1710399856124	96.77	Payé	\N
RECEIPT_1710401730315	408.02	Payé	ethan
RECEIPT_1710404229661	140.89	Payé	\N
RECEIPT_1710404352352	152.95	Payé	\N
RECEIPT_1710401716297	148.79	Payé	ethan
RECEIPT_1711391617598	75.35	Payé	felania
RECEIPT_1711448696163	96.38	Payé	felania
RECEIPT_1711264283443	75.35	Payé	\N
RECEIPT_1712138672851	0	Payé	felania
RECEIPT_1712563061302	0	en cours	felania
RECEIPT_1710401707099	109.91	Payé	ethan
RECEIPT_1712679835616	5541.85	en cours	\N
RECEIPT_1712842527711	144.57	en cours	felania
RECEIPT_1712842565440	144.57	en cours	felania
RECEIPT_1710404971629	136.97	Payé	\N
RECEIPT_1713442583931	49	en cours	\N
RECEIPT_1711264306687	67.63	Payé	\N
RECEIPT_1713484445433	135.26	en cours	\N
RECEIPT_1713496256403	19.6	en cours	felania
RECEIPT_1709794498851	75.25	en cours	\N
RECEIPT_1709794630914	113.85	en cours	\N
RECEIPT_1709794683281	183.45	en cours	\N
\.


--
-- TOC entry 3366 (class 0 OID 73778)
-- Dependencies: 219
-- Data for Name: receipt_items; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.receipt_items (receipt_id, idmedicament, nom, quantite, total, status, prix) FROM stdin;
RECEIPT_1710399649708	6	Bepanthen Crème	2	27.06	en cours	\N
RECEIPT_1710399649708	5	Nurofen 200mg	1	48.19	en cours	\N
RECEIPT_1710400596774	4	Voltarene 50mg/100Ml	1	67.63	en cours	67.63
RECEIPT_1710400596774	3	Doliprane 100mg	2	150.70	en cours	75.35
RECEIPT_1710401730315	3	Doliprane 100mg	2	150.70	Payé	75.35
RECEIPT_1710401730315	2	Advil 400mg	3	209.13	Payé	69.71
RECEIPT_1710401730315	5	Nurofen 200mg	1	48.19	Payé	48.19
RECEIPT_1710404229661	4	Voltarene 50mg/100Ml	1	67.63	Payé	67.63
RECEIPT_1710404229661	1	Panadol 500mg	2	73.26	Payé	36.63
RECEIPT_1710404352352	6	Bepanthen Crème	1	13.53	Payé	13.53
RECEIPT_1710404352352	2	Advil 400mg	2	139.42	Payé	69.71
RECEIPT_1710401716297	6	Bepanthen Crème	1	13.53	Payé	13.53
RECEIPT_1710401716297	4	Voltarene 50mg/100Ml	2	135.26	Payé	67.63
RECEIPT_1711391617598	3	Panadol 500mg	1	75.35	Payé	75.35
RECEIPT_1711448696163	5	Nurofen 200mg	2	96.38	Payé	48.19
RECEIPT_1711448696163	17	Paracétamol	8	0.00	Payé	0.00
RECEIPT_1711264283443	3	Doliprane 100mg	1	75.35	Payé	75.35
RECEIPT_1712138672851	18	Doliprane	125	0.00	Payé	0.00
RECEIPT_1712563061302	19	Paracétamol	3	0.00	en cours	0.00
RECEIPT_1710401707099	6	Bepanthen Crème	1	13.53	Payé	13.53
RECEIPT_1710401707099	5	Nurofen 200mg	2	96.38	Payé	48.19
RECEIPT_1712679835616	5	Nurofen 200mg	115	5541.85	en cours	48.19
RECEIPT_1712842527711	5	Nurofen 200mg	3	144.57	en cours	48.19
RECEIPT_1712842565440	5	Nurofen 200mg	3	144.57	en cours	48.19
RECEIPT_1710404971629	5	Nurofen 200mg	2	96.38	Payé	48.19
RECEIPT_1710404971629	6	Bepanthen Crème	3	40.59	Payé	13.53
RECEIPT_1713442583931	6	Bepanthen Crème	5	49.00	en cours	9.80
RECEIPT_1711264306687	4	Voltarene 50mg/100Ml	1	67.63	Payé	67.63
RECEIPT_1713484445433	4	Voltarene 50mg/100Ml	2	135.26	en cours	67.63
RECEIPT_1713496256403	20	Lamisil 250 mg	2	0.00	en cours	0.00
RECEIPT_1713496256403	6	Bepanthen Crème	2	19.60	en cours	9.80
RECEIPT_1709794498851	5	Nurofen 200mg	1	48.19	\N	\N
RECEIPT_1709794498851	6	Bepanthen Crème	2	27.06	\N	\N
RECEIPT_1709794683281	4	Voltarene 50mg/100Ml	2	135.26	en cours	\N
RECEIPT_1709794683281	5	Nurofen 200mg	1	48.19	en cours	\N
\.


--
-- TOC entry 3369 (class 0 OID 73785)
-- Dependencies: 222
-- Data for Name: user_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_logs (id_useraccounts, username, login_time, login_sucessful) FROM stdin;
29	felaniaina	2024-03-26 14:46:27.716	t
29	felaniaina	2024-03-26 14:47:10.616	t
\N	felaniaina	2024-03-26 15:11:43.574	f
28	felania	2024-03-27 12:27:57.182	t
\N	Felania	2024-04-02 10:55:52.354	f
28	felania	2024-04-02 10:56:02.678	t
28	felania	2024-04-03 13:58:25.635	t
28	felania	2024-04-03 14:08:33.099	t
28	felania	2024-04-07 13:19:34.126	t
28	felania	2024-04-07 14:08:39.257	t
28	felania	2024-04-07 14:25:15.236	t
28	felania	2024-04-07 14:34:44.674	t
28	felania	2024-04-07 14:41:44.031	t
28	felania	2024-04-07 14:59:16.255	t
28	felania	2024-04-07 15:00:50.382	t
28	felania	2024-04-07 15:02:08.048	t
28	felania	2024-04-07 15:06:52.737	t
28	felania	2024-04-07 15:12:40.112	t
28	felania	2024-04-07 15:14:39.153	t
28	felania	2024-04-07 15:28:11.952	t
28	felania	2024-04-07 15:44:10.753	t
28	felania	2024-04-07 15:45:13.831	t
28	felania	2024-04-07 15:51:18.301	t
28	felania	2024-04-07 15:52:23.881	t
28	felania	2024-04-07 15:56:04.913	t
28	felania	2024-04-07 15:58:16.186	t
28	felania	2024-04-07 15:59:30.238	t
28	felania	2024-04-07 16:02:35.276	t
28	felania	2024-04-07 16:15:32.319	t
28	felania	2024-04-07 16:16:31.284	t
28	felania	2024-04-07 16:23:35.525	t
28	felania	2024-04-07 16:26:32.549	t
28	felania	2024-04-07 16:28:51.566	t
28	felania	2024-04-07 16:32:13.93	t
28	felania	2024-04-07 16:37:51.225	t
28	felania	2024-04-07 17:54:54.287	t
28	felania	2024-04-07 17:56:33.564	t
28	felania	2024-04-07 17:59:55.667	t
28	felania	2024-04-07 18:04:49.316	t
28	felania	2024-04-07 18:22:24.601	t
28	felania	2024-04-07 18:34:28.491	t
28	felania	2024-04-07 18:36:11.262	t
28	felania	2024-04-07 18:37:16.754	t
28	felania	2024-04-07 18:45:30.209	t
28	felania	2024-04-07 18:49:32.117	t
28	felania	2024-04-07 20:00:00.663	t
28	felania	2024-04-07 20:31:00.809	t
28	felania	2024-04-07 20:35:35.304	t
28	felania	2024-04-07 22:07:02.149	t
28	felania	2024-04-08 08:14:02.126	t
28	felania	2024-04-08 10:20:53.873	t
28	felania	2024-04-08 11:07:46.738	t
28	felania	2024-04-08 11:45:02.325	t
28	felania	2024-04-08 11:48:34.524	t
28	felania	2024-04-08 12:16:54.772	t
\N	felaniaina	2024-04-08 12:26:28.618	f
28	felania	2024-04-08 12:33:35.775	t
28	felania	2024-04-08 13:28:38.855	t
28	felania	2024-04-08 13:44:24.594	t
28	felania	2024-04-08 14:07:30.188	t
28	felania	2024-04-08 14:09:22.559	t
28	felania	2024-04-08 15:34:37.704	t
28	felania	2024-04-11 17:35:04.481	t
28	felania	2024-04-19 04:10:22.472	t
28	felania	2024-04-19 04:10:37.986	t
28	felania	2024-04-19 04:18:46.057	t
28	felania	2024-04-19 05:25:58.23	t
1	ethan	2024-02-13 11:34:44.792	t
1	ethan	2024-02-13 11:36:54.61	t
1	ethan	2024-02-13 11:40:37.383	t
1	ethan	2024-02-13 12:52:10.325	t
1	ethan	2024-02-13 12:57:45.521	t
1	ethan	2024-02-13 13:00:37.144	t
1	ethan	2024-02-13 14:02:45.999	t
1	ethan	2024-02-13 14:03:21.221	t
1	ethan	2024-02-13 14:05:34.781	t
1	ethan	2024-02-13 14:06:15.514	t
1	ethan	2024-02-13 14:08:42.665	t
1	ethan	2024-02-13 14:27:06.116	t
1	ethan	2024-02-13 14:38:05.502	t
1	ethan	2024-02-13 14:43:36.92	t
1	ethan	2024-02-13 14:56:20.642	t
1	ethan	2024-02-13 14:59:20.528	t
1	ethan	2024-02-13 15:00:19.549	t
1	ethan	2024-02-13 15:01:44.616	t
1	ethan	2024-02-13 15:43:06.568	t
1	ethan	2024-02-13 16:04:27.385	t
1	ethan	2024-02-13 16:25:07.239	t
1	ethan	2024-02-13 16:30:02.519	t
1	ethan	2024-02-13 16:33:17.429	t
1	ethan	2024-02-13 16:43:04.82	t
1	ethan	2024-02-13 16:44:46.492	t
1	ethan	2024-02-13 16:56:02.748	t
1	ethan	2024-02-13 16:58:31.887	t
1	ethan	2024-02-14 08:37:39.461	t
\N	ethan	2024-02-15 09:22:13.362	f
1	ethan	2024-02-15 09:22:17.518	t
1	ethan	2024-02-15 15:25:51.903	t
1	ethan	2024-02-15 15:48:26.94	t
\N	ethan	2024-03-04 13:27:02.82	f
1	ethan	2024-03-04 13:27:07.215	t
1	ethan	2024-03-07 11:01:58.895	t
\N	ethan	2024-03-07 11:17:42.432	f
\N	ethan	2024-03-07 11:17:42.771	f
1	ethan	2024-03-07 11:17:50.837	t
\N	nikhil	2024-03-07 11:18:41.995	f
2	mohivesh	2024-03-07 11:19:11.649	t
29	felaniaina	2024-03-26 14:46:52.485	t
28	felania	2024-03-26 14:45:41.552	t
28	felania	2024-03-26 14:47:43.44	t
29	felaniaina	2024-03-26 15:11:50.872	t
\N	Felania	2024-04-02 10:55:59.465	f
28	felania	2024-04-02 11:12:13.216	t
28	felania	2024-04-03 14:05:46.365	t
28	felania	2024-04-07 14:08:29.021	t
28	felania	2024-04-07 14:18:40.266	t
28	felania	2024-04-07 14:34:09.53	t
28	felania	2024-04-07 14:39:38.466	t
28	felania	2024-04-07 14:47:19.411	t
28	felania	2024-04-07 15:00:29.644	t
28	felania	2024-04-07 15:01:39.546	t
28	felania	2024-04-07 15:03:14.883	t
28	felania	2024-04-07 15:08:26.14	t
28	felania	2024-04-07 15:13:37.09	t
28	felania	2024-04-07 15:15:03.947	t
28	felania	2024-04-07 15:32:36.86	t
28	felania	2024-04-07 15:44:47.496	t
28	felania	2024-04-07 15:45:46.644	t
28	felania	2024-04-07 15:51:46.76	t
28	felania	2024-04-07 15:54:40.196	t
28	felania	2024-04-07 15:57:31.527	t
28	felania	2024-04-07 15:58:53.262	t
28	felania	2024-04-07 16:01:34.211	t
28	felania	2024-04-07 16:05:08.205	t
28	felania	2024-04-07 16:16:00.923	t
28	felania	2024-04-07 16:21:28.585	t
28	felania	2024-04-07 16:24:42.3	t
28	felania	2024-04-07 16:27:05.062	t
28	felania	2024-04-07 16:30:53.255	t
28	felania	2024-04-07 16:34:26.65	t
28	felania	2024-04-07 17:48:28.987	t
28	felania	2024-04-07 17:55:23.59	t
28	felania	2024-04-07 17:56:49.419	t
28	felania	2024-04-07 18:02:48.251	t
28	felania	2024-04-07 18:20:45.157	t
28	felania	2024-04-07 18:33:54.883	t
28	felania	2024-04-07 18:35:37.827	t
28	felania	2024-04-07 18:36:46.797	t
28	felania	2024-04-07 18:38:34.473	t
28	felania	2024-04-07 18:47:52.077	t
28	felania	2024-04-07 19:38:09.372	t
28	felania	2024-04-07 20:01:58.949	t
28	felania	2024-04-07 20:35:03.751	t
28	felania	2024-04-07 20:37:52.682	t
28	felania	2024-04-08 08:13:45.587	t
28	felania	2024-04-08 08:57:34.766	t
28	felania	2024-04-08 11:00:50.687	t
28	felania	2024-04-08 11:41:53.867	t
28	felania	2024-04-08 11:46:09.389	t
28	felania	2024-04-08 11:52:20.549	t
28	felania	2024-04-08 12:17:46.722	t
28	felania	2024-04-08 12:26:32.148	t
28	felania	2024-04-08 13:26:13.84	t
28	felania	2024-04-08 13:32:53.844	t
28	felania	2024-04-08 14:04:52.281	t
28	felania	2024-04-08 14:07:40.797	t
28	felania	2024-04-08 15:34:02.128	t
\N	felania	2024-04-19 04:10:30.677	f
28	felania	2024-04-19 04:11:59.547	t
28	felania	2024-04-19 04:26:04.489	t
1	ethan	2023-12-04 09:35:48.306	t
\N	nikhil	2023-12-04 09:36:21.582	f
\N	nikhil	2023-12-04 09:36:29.442	f
\N	nikhil	2023-12-04 09:36:30.593	f
2	mohivesh	2023-12-04 09:44:54.372	t
1	ethan	2023-12-04 10:10:17.29	t
1	ethan	2023-12-04 10:10:43.004	t
1	ethan	2023-12-04 13:16:35.2	t
2	mohivesh	2023-12-04 14:06:02.447	t
\N	mohivesh	2023-12-04 14:06:48.225	f
2	mohivesh	2023-12-04 14:07:11.649	t
1	ethan	2023-12-04 14:08:00.931	t
1	ethan	2023-12-04 14:26:37.266	t
1	ethan	2023-12-04 14:28:31.608	t
1	ethan	2023-12-04 14:32:24.256	t
1	ethan	2023-12-04 14:34:42.608	t
1	ethan	2023-12-04 18:35:45.525	t
1	ethan	2024-01-10 13:38:24.004	t
1	ethan	2024-01-10 13:44:31.448	t
1	ethan	2024-01-10 14:07:02.609	t
1	ethan	2024-01-10 14:10:31.04	t
1	ethan	2024-01-10 14:16:04.934	t
1	ethan	2024-01-10 14:20:35.087	t
1	ethan	2024-01-10 14:49:07.751	t
1	ethan	2024-01-10 14:49:26.937	t
1	ethan	2024-01-10 14:51:45.343	t
1	ethan	2024-01-10 14:53:14.977	t
1	ethan	2024-01-10 14:53:58.911	t
1	ethan	2024-01-10 14:54:16.534	t
1	ethan	2024-01-10 14:55:34.825	t
1	ethan	2024-01-10 15:31:26.028	t
1	ethan	2024-01-10 15:37:31.834	t
1	ethan	2024-01-10 18:13:51.574	t
1	ethan	2024-01-10 18:21:29.767	t
1	ethan	2024-01-11 10:28:20.317	t
1	ethan	2024-01-11 11:14:55.048	t
1	ethan	2024-01-11 11:22:56.219	t
1	ethan	2024-01-13 12:42:34.551	t
1	ethan	2024-01-13 17:25:19.402	t
1	ethan	2024-01-17 16:11:03.246	t
1	ethan	2024-01-17 16:33:38.048	t
1	ethan	2024-02-03 20:14:21.71	t
1	ethan	2024-02-03 20:27:43.311	t
1	ethan	2024-02-03 22:10:13.185	t
1	ethan	2024-02-03 22:13:32.794	t
1	ethan	2024-02-03 22:17:54.162	t
1	ethan	2024-02-03 22:28:48.032	t
1	ethan	2024-02-03 22:30:26.191	t
1	ethan	2024-02-03 22:32:32.138	t
1	ethan	2024-02-03 22:35:27.386	t
1	ethan	2024-02-03 22:54:24.783	t
1	ethan	2024-02-03 22:56:27.055	t
1	ethan	2024-02-03 23:00:07.609	t
1	ethan	2024-02-03 23:00:54.988	t
1	ethan	2024-02-03 23:02:52.711	t
1	ethan	2024-02-03 23:04:55.511	t
1	ethan	2024-02-04 07:40:03.515	t
1	ethan	2024-02-04 07:41:24.429	t
1	ethan	2024-02-04 07:45:50.098	t
1	ethan	2024-02-04 07:58:18.848	t
1	ethan	2024-02-04 08:00:22.098	t
1	ethan	2024-02-04 08:01:01.548	t
1	ethan	2024-02-04 08:01:25.002	t
1	ethan	2024-02-04 08:04:55.989	t
1	ethan	2024-02-04 08:18:46.253	t
1	ethan	2024-02-04 08:23:37.623	t
1	ethan	2024-02-04 08:26:17.719	t
1	ethan	2024-02-04 08:42:23.761	t
1	ethan	2024-02-04 08:44:44.851	t
1	ethan	2024-02-13 11:10:22.919	t
1	ethan	2024-02-13 11:15:51.178	t
1	ethan	2024-02-13 11:30:30.206	t
1	ethan	2024-02-13 11:33:48.755	t
\.


--
-- TOC entry 3370 (class 0 OID 73789)
-- Dependencies: 223
-- Data for Name: useraccounts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.useraccounts (id_useraccounts, username, firstname, lastname, mdp_pharm, last_login, permission, status) FROM stdin;
31	FANOMEZANTSOA	Voahary	30	123456	2024-04-11 15:32:41.868547	User	t
29	32	Voahary	FANOMEZANTSOA	123456	2024-03-26 15:11:50.872	user	t
28	felania	Fanomezantsoa	Felania	12345	2024-04-19 05:25:58.23	SU	t
8	andrew	Andrew	Tuck	ctwqf43n	2023-12-04 09:06:38.602978	User	f
11	sab	Sabrina	Tuck	ctwqf43n	2023-12-04 18:36:12.903752	User	f
14	Roy	Zantakwan	zantakwan	ctwqf43n	2024-01-11 11:23:23.392966	User	t
20	1	1	1	1	2024-02-13 16:57:45.433294	User	t
13	andrew1	Ethan	Labourette	ctwqf43n	2024-01-11 11:21:34.470831	User	f
23	123	1234	2	1	2024-02-13 16:58:57.104442	User	f
1	ethan	Ethan	Tuckmansing	ctwqf43n	2024-03-07 11:17:50.837	SU	t
2	mohivesh	Nikhil	Mohit	ctwqf43n	2024-03-07 11:19:11.649	User	t
\.


--
-- TOC entry 3376 (class 0 OID 0)
-- Dependencies: 216
-- Name: medicament_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicament_id_seq', 16, true);


--
-- TOC entry 3377 (class 0 OID 0)
-- Dependencies: 220
-- Name: sequence_employee; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sequence_employee', 1, true);


--
-- TOC entry 3378 (class 0 OID 0)
-- Dependencies: 221
-- Name: sequence_utilisateur; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sequence_utilisateur', 23, true);


--
-- TOC entry 3208 (class 2606 OID 73796)
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- TOC entry 3210 (class 2606 OID 73798)
-- Name: fournisseurs fournisseurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fournisseurs
    ADD CONSTRAINT fournisseurs_pkey PRIMARY KEY (idfournisseur);


--
-- TOC entry 3212 (class 2606 OID 73800)
-- Name: medicament medicament_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicament
    ADD CONSTRAINT medicament_pkey PRIMARY KEY (id);


--
-- TOC entry 3214 (class 2606 OID 73802)
-- Name: receipt receipt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.receipt
    ADD CONSTRAINT receipt_pkey PRIMARY KEY (receipt_id);


--
-- TOC entry 3216 (class 2606 OID 73804)
-- Name: useraccounts useraccounts_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.useraccounts
    ADD CONSTRAINT useraccounts_username_key UNIQUE (username);


--
-- TOC entry 3217 (class 2620 OID 73805)
-- Name: medicament update_date_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_date_trigger BEFORE UPDATE ON public.medicament FOR EACH ROW WHEN ((old.* IS DISTINCT FROM new.*)) EXECUTE FUNCTION public.update_date_mise_a_jour();


--
-- TOC entry 3218 (class 2620 OID 73806)
-- Name: useraccounts update_last_login_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_last_login_trigger BEFORE UPDATE ON public.useraccounts FOR EACH ROW EXECUTE FUNCTION public.useraccounts_last_login_trigger();


-- Completed on 2024-04-19 08:11:30

--
-- PostgreSQL database dump complete
--

