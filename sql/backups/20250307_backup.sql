--
-- PostgreSQL database dump
--

-- Dumped from database version 15.10
-- Dumped by pg_dump version 17.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: item_availability; Type: TYPE; Schema: public; Owner: doadmin
--

CREATE TYPE public.item_availability AS ENUM (
    'AVAILABLE',
    'HIDDEN',
    'NOT_AVAILABLE'
);


ALTER TYPE public.item_availability OWNER TO doadmin;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: doadmin
--

CREATE TYPE public.order_status AS ENUM (
    'PENDING',
    'ACCEPTED',
    'DECLINED'
);


ALTER TYPE public.order_status OWNER TO doadmin;

--
-- Name: payment_type; Type: TYPE; Schema: public; Owner: doadmin
--

CREATE TYPE public.payment_type AS ENUM (
    'CASH',
    'CARD'
);


ALTER TYPE public.payment_type OWNER TO doadmin;

--
-- Name: staff_role; Type: TYPE; Schema: public; Owner: doadmin
--

CREATE TYPE public.staff_role AS ENUM (
    'SUPPORT',
    'ADMIN',
    'MANAGER',
    'WAITER'
);


ALTER TYPE public.staff_role OWNER TO doadmin;

--
-- Name: unit; Type: TYPE; Schema: public; Owner: doadmin
--

CREATE TYPE public.unit AS ENUM (
    'G',
    'KG',
    'MG',
    'L',
    'ML',
    'PI'
);


ALTER TYPE public.unit OWNER TO doadmin;

--
-- Name: CAST (character varying AS public.order_status); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.order_status) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (character varying AS public.payment_type); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.payment_type) WITH INOUT AS IMPLICIT;


--
-- Name: CAST (character varying AS public.staff_role); Type: CAST; Schema: -; Owner: -
--

CREATE CAST (character varying AS public.staff_role) WITH INOUT AS IMPLICIT;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: flyway_schema_history; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.flyway_schema_history (
    installed_rank integer NOT NULL,
    version character varying(50),
    description character varying(200) NOT NULL,
    type character varying(20) NOT NULL,
    script character varying(1000) NOT NULL,
    checksum integer,
    installed_by character varying(100) NOT NULL,
    installed_on timestamp without time zone DEFAULT now() NOT NULL,
    execution_time integer NOT NULL,
    success boolean NOT NULL
);


ALTER TABLE public.flyway_schema_history OWNER TO doadmin;

--
-- Name: t_branch; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_branch (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    client_id bigint NOT NULL,
    address_line1 character varying(255) NOT NULL,
    address_line2 character varying(255),
    city character varying(50),
    postal_code character varying(20),
    country_code character varying(3) NOT NULL
);


ALTER TABLE public.t_branch OWNER TO doadmin;

--
-- Name: t_branch_item; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_branch_item (
    branch_id bigint NOT NULL,
    item_id bigint NOT NULL,
    availability public.item_availability NOT NULL
);


ALTER TABLE public.t_branch_item OWNER TO doadmin;

--
-- Name: t_call_waiter; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_call_waiter (
    id bigint NOT NULL,
    table_session_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    acknowledged_at timestamp without time zone,
    acknowledged_by bigint
);


ALTER TABLE public.t_call_waiter OWNER TO doadmin;

--
-- Name: t_call_waiter_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_call_waiter_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_call_waiter_id_seq OWNER TO doadmin;

--
-- Name: t_call_waiter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_call_waiter_id_seq OWNED BY public.t_call_waiter.id;


--
-- Name: t_category; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_category (
    id bigint NOT NULL,
    sequence integer NOT NULL,
    default_name character varying(50) NOT NULL,
    client_id bigint NOT NULL,
    show_images boolean DEFAULT false,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    deleted_at timestamp without time zone
);


ALTER TABLE public.t_category OWNER TO doadmin;

--
-- Name: t_category_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_category_id_seq OWNER TO doadmin;

--
-- Name: t_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_category_id_seq OWNED BY public.t_category.id;


--
-- Name: t_category_localization; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_category_localization (
    category_id bigint NOT NULL,
    localization character varying(2) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.t_category_localization OWNER TO doadmin;

--
-- Name: t_client; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_client (
    id bigint NOT NULL,
    email character varying(100) NOT NULL,
    name character varying(100) NOT NULL,
    default_localization character varying(2) DEFAULT 'en'::character varying NOT NULL,
    currency character varying(3) NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    key character varying(100)
);


ALTER TABLE public.t_client OWNER TO doadmin;

--
-- Name: t_client_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_client_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_client_id_seq OWNER TO doadmin;

--
-- Name: t_client_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_client_id_seq OWNED BY public.t_client.id;


--
-- Name: t_client_secondary_language; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_client_secondary_language (
    client_id bigint NOT NULL,
    localization character varying(2) NOT NULL
);


ALTER TABLE public.t_client_secondary_language OWNER TO doadmin;

--
-- Name: t_user; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_user (
    id bigint NOT NULL,
    username character varying(100) NOT NULL,
    password character varying(100) NOT NULL,
    client_id bigint NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    role public.staff_role DEFAULT 'WAITER'::public.staff_role NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    device_token character varying(255),
    email character varying(100) NOT NULL
);


ALTER TABLE public.t_user OWNER TO doadmin;

--
-- Name: t_control_panel_user_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_control_panel_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_control_panel_user_id_seq OWNER TO doadmin;

--
-- Name: t_control_panel_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_control_panel_user_id_seq OWNED BY public.t_user.id;


--
-- Name: t_item; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_item (
    id bigint NOT NULL,
    price numeric(9,2) NOT NULL,
    sequence integer NOT NULL,
    category_id bigint NOT NULL,
    image_url character varying(256),
    quantity1 numeric(7,3),
    unit1 public.unit,
    quantity2 numeric(7,3),
    unit2 public.unit,
    quantity3 numeric(7,3),
    unit3 public.unit,
    quantity4 numeric(7,3),
    unit4 public.unit,
    quantity5 numeric(7,3),
    unit5 public.unit,
    default_name character varying(100) NOT NULL,
    default_description character varying(300),
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    image_blur_hash character varying(200),
    deleted_at timestamp without time zone
);


ALTER TABLE public.t_item OWNER TO doadmin;

--
-- Name: t_item_localization; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_item_localization (
    item_id bigint NOT NULL,
    localization character varying(2) NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(300)
);


ALTER TABLE public.t_item_localization OWNER TO doadmin;

--
-- Name: t_meal_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_meal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_meal_id_seq OWNER TO doadmin;

--
-- Name: t_meal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_meal_id_seq OWNED BY public.t_item.id;


--
-- Name: t_order; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_order (
    id bigint NOT NULL,
    status public.order_status DEFAULT 'PENDING'::public.order_status NOT NULL,
    table_session_id bigint NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status_changed_at timestamp without time zone,
    status_changed_by bigint,
    comment character varying(256) DEFAULT NULL::character varying
);


ALTER TABLE public.t_order OWNER TO doadmin;

--
-- Name: t_order_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_order_id_seq OWNER TO doadmin;

--
-- Name: t_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_order_id_seq OWNED BY public.t_order.id;


--
-- Name: t_order_item; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_order_item (
    id bigint NOT NULL,
    item_id bigint NOT NULL,
    item_count integer NOT NULL,
    order_id bigint NOT NULL
);


ALTER TABLE public.t_order_item OWNER TO doadmin;

--
-- Name: t_order_meal_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_order_meal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_order_meal_id_seq OWNER TO doadmin;

--
-- Name: t_order_meal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_order_meal_id_seq OWNED BY public.t_order_item.id;


--
-- Name: t_payment; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_payment (
    id bigint NOT NULL,
    table_session_id bigint NOT NULL,
    type public.payment_type NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    acknowledged_at timestamp without time zone,
    acknowledged_by bigint
);


ALTER TABLE public.t_payment OWNER TO doadmin;

--
-- Name: t_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_payment_id_seq OWNER TO doadmin;

--
-- Name: t_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_payment_id_seq OWNED BY public.t_payment.id;


--
-- Name: t_restaurant_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_restaurant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_restaurant_id_seq OWNER TO doadmin;

--
-- Name: t_restaurant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_restaurant_id_seq OWNED BY public.t_branch.id;


--
-- Name: t_table; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_table (
    id bigint NOT NULL,
    number integer,
    branch_id bigint NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE public.t_table OWNER TO doadmin;

--
-- Name: t_table_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_table_id_seq OWNER TO doadmin;

--
-- Name: t_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_table_id_seq OWNED BY public.t_table.id;


--
-- Name: t_table_session; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_table_session (
    id bigint NOT NULL,
    table_id bigint NOT NULL,
    closed_at timestamp without time zone,
    table_session_uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL
);


ALTER TABLE public.t_table_session OWNER TO doadmin;

--
-- Name: t_table_session_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_table_session_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_table_session_id_seq OWNER TO doadmin;

--
-- Name: t_table_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_table_session_id_seq OWNED BY public.t_table_session.id;


--
-- Name: t_user_branch; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_user_branch (
    user_id bigint NOT NULL,
    branch_id bigint NOT NULL
);


ALTER TABLE public.t_user_branch OWNER TO doadmin;

--
-- Name: t_user_table; Type: TABLE; Schema: public; Owner: doadmin
--

CREATE TABLE public.t_user_table (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    table_id bigint NOT NULL,
    started_watching_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    stopped_watching_at timestamp without time zone
);


ALTER TABLE public.t_user_table OWNER TO doadmin;

--
-- Name: t_user_table_id_seq; Type: SEQUENCE; Schema: public; Owner: doadmin
--

CREATE SEQUENCE public.t_user_table_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.t_user_table_id_seq OWNER TO doadmin;

--
-- Name: t_user_table_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: doadmin
--

ALTER SEQUENCE public.t_user_table_id_seq OWNED BY public.t_user_table.id;


--
-- Name: t_branch id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch ALTER COLUMN id SET DEFAULT nextval('public.t_restaurant_id_seq'::regclass);


--
-- Name: t_call_waiter id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_call_waiter ALTER COLUMN id SET DEFAULT nextval('public.t_call_waiter_id_seq'::regclass);


--
-- Name: t_category id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category ALTER COLUMN id SET DEFAULT nextval('public.t_category_id_seq'::regclass);


--
-- Name: t_client id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client ALTER COLUMN id SET DEFAULT nextval('public.t_client_id_seq'::regclass);


--
-- Name: t_item id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item ALTER COLUMN id SET DEFAULT nextval('public.t_meal_id_seq'::regclass);


--
-- Name: t_order id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order ALTER COLUMN id SET DEFAULT nextval('public.t_order_id_seq'::regclass);


--
-- Name: t_order_item id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order_item ALTER COLUMN id SET DEFAULT nextval('public.t_order_meal_id_seq'::regclass);


--
-- Name: t_payment id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_payment ALTER COLUMN id SET DEFAULT nextval('public.t_payment_id_seq'::regclass);


--
-- Name: t_table id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table ALTER COLUMN id SET DEFAULT nextval('public.t_table_id_seq'::regclass);


--
-- Name: t_table_session id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table_session ALTER COLUMN id SET DEFAULT nextval('public.t_table_session_id_seq'::regclass);


--
-- Name: t_user id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user ALTER COLUMN id SET DEFAULT nextval('public.t_control_panel_user_id_seq'::regclass);


--
-- Name: t_user_table id; Type: DEFAULT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_table ALTER COLUMN id SET DEFAULT nextval('public.t_user_table_id_seq'::regclass);


--
-- Data for Name: flyway_schema_history; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.flyway_schema_history (installed_rank, version, description, type, script, checksum, installed_by, installed_on, execution_time, success) FROM stdin;
1	1	<< Flyway Baseline >>	BASELINE	<< Flyway Baseline >>	\N	null	2023-03-26 08:53:07.494315	0	t
2	202011230053	t restaurant	SQL	V202011230053__t_restaurant.sql	1412130531	doadmin	2023-03-26 08:53:17.369317	752	t
3	202011240230	t restaurant details	SQL	V202011240230__t_restaurant_details.sql	1027693742	doadmin	2023-03-26 08:53:19.867242	752	t
4	202011240240	t meal	SQL	V202011240240__t_meal.sql	1397319754	doadmin	2023-03-26 08:53:22.245856	746	t
5	202011240241	t meal details	SQL	V202011240241__t_meal_details.sql	856803386	doadmin	2023-03-26 08:53:24.597861	914	t
6	202011240312	t restaurant t restaurant details	SQL	V202011240312__t_restaurant_t_restaurant_details.sql	1081019631	doadmin	2023-03-26 08:53:27.142977	1129	t
7	202011240313	t meal t meal details	SQL	V202011240313__t_meal_t_meal_details.sql	-981760285	doadmin	2023-03-26 08:53:29.888295	2585	t
8	202011250057	t bot	SQL	V202011250057__t_bot.sql	815681822	doadmin	2023-03-26 08:53:34.06171	903	t
9	202012120001	t table	SQL	V202012120001__t_table.sql	-378929902	doadmin	2023-03-26 08:53:36.637181	737	t
10	202012121800	t order meal	SQL	V202012121800__t_order_meal.sql	-534486820	doadmin	2023-03-26 08:53:38.972663	740	t
11	202012140141	t telegram user	SQL	V202012140141__t_telegram_user.sql	425325923	doadmin	2023-03-26 08:53:41.311952	736	t
12	202012262113	t bot	SQL	V202012262113__t_bot.sql	-871433118	doadmin	2023-03-26 08:53:43.643473	902	t
13	202012262204	t table	SQL	V202012262204__t_table.sql	-1935924407	doadmin	2023-03-26 08:53:46.282153	860	t
14	202012270739	t table	SQL	V202012270739__t_table.sql	-737011976	doadmin	2023-03-26 08:53:48.737882	742	t
15	202012280120	t restaurant	SQL	V202012280120__t_restaurant.sql	1127701467	doadmin	2023-03-26 08:53:51.088247	1014	t
16	202012280121	t table	SQL	V202012280121__t_table.sql	-1826316452	doadmin	2023-03-26 08:53:53.7227	978	t
17	202101031840	t table	SQL	V202101031840__t_table.sql	176110596	doadmin	2023-03-26 08:53:56.549946	744	t
18	202101031844	t telegram user	SQL	V202101031844__t_telegram_user.sql	-1673649721	doadmin	2023-03-26 08:53:58.914161	1372	t
19	202102192100	t category	SQL	V202102192100__t_category.sql	-636324415	doadmin	2023-03-26 08:54:01.898029	749	t
20	202102192110	t category details	SQL	V202102192110__t_category_details.sql	-238564299	doadmin	2023-03-26 08:54:04.269359	950	t
21	202102192111	t category t category details	SQL	V202102192111__t_category_t_category_details.sql	619360370	doadmin	2023-03-26 08:54:07.32111	995	t
22	202102192120	t meal	SQL	V202102192120__t_meal.sql	1139362791	doadmin	2023-03-26 08:54:09.938646	1118	t
23	202102192130	t meal details	SQL	V202102192130__t_meal_details.sql	-1566315876	doadmin	2023-03-26 08:54:12.672579	743	t
24	202102222300	t control panel user	SQL	V202102222300__t_control_panel_user.sql	82260147	doadmin	2023-03-26 08:54:15.205028	780	t
25	202102222345	t control panel user	SQL	V202102222345__t_control_panel_user.sql	567818301	doadmin	2023-03-26 08:54:17.610564	1010	t
26	202102281709	t meal	SQL	V202102281709__t_meal.sql	-2109908321	doadmin	2023-03-26 08:54:20.233345	739	t
27	202103091956	t meal	SQL	V202103091956__t_meal.sql	-1677853183	doadmin	2023-03-26 08:54:22.570794	743	t
28	202103161230	t restaurant control panel user	SQL	V202103161230__t_restaurant_control_panel_user.sql	-826343524	doadmin	2023-03-26 08:54:25.067554	812	t
29	202103161240	t restaurant control panel user	SQL	V202103161240__t_restaurant_control_panel_user.sql	-255659186	doadmin	2023-03-26 08:54:27.493521	748	t
30	202103190220	t meal	SQL	V202103190220__t_meal.sql	1682890366	doadmin	2023-03-26 08:54:29.857859	875	t
31	202103211720	t meal	SQL	V202103211720__t_meal.sql	-978078032	doadmin	2023-03-26 08:54:32.318179	1956	t
32	202103211730	t meal	SQL	V202103211730__t_meal.sql	2089926301	doadmin	2023-03-26 08:54:36.112578	858	t
33	202103211731	t meal	SQL	V202103211731__t_meal.sql	-1718782379	doadmin	2023-03-26 08:54:38.566061	853	t
34	202103242213	t order meal	SQL	V202103242213__t_order_meal.sql	778361866	doadmin	2023-03-26 08:54:41.007248	736	t
35	202103271600	t category	SQL	V202103271600__t_category.sql	-1128771090	doadmin	2023-03-26 08:54:43.333082	864	t
36	202304052200	t meal	SQL	V202304052200__t_meal.sql	-683542642	doadmin	2023-04-08 02:08:37.132487	618	t
37	202304052210	t category	SQL	V202304052210__t_category.sql	1156225791	doadmin	2023-04-08 02:08:38.537991	540	t
38	202304052220	t restaurant	SQL	V202304052220__t_restaurant.sql	1343047730	doadmin	2023-04-08 02:08:39.799666	480	t
39	202304081955	t meal	SQL	V202304081955__t_meal.sql	1540406604	doadmin	2023-04-11 14:46:58.968011	556	t
40	202304130000	t client	SQL	V202304130000__t_client.sql	1703704356	doadmin	2023-06-01 15:33:46.390354	1494	t
41	202304130100	t restaurant meal	SQL	V202304130100__t_restaurant_meal.sql	-247392235	doadmin	2023-06-01 15:33:49.143264	729	t
42	202304130200	t control panel user	SQL	V202304130200__t_control_panel_user.sql	549287280	doadmin	2023-06-01 15:33:51.033348	721	t
43	202304130300	t restaurant t table	SQL	V202304130300__t_restaurant_t_table.sql	1356412144	doadmin	2023-06-01 15:33:52.867643	630	t
44	202304220100	t client secondary language	SQL	V202304220100__t_client_secondary_language.sql	1429407722	doadmin	2023-06-01 15:33:54.651931	649	t
45	202305241853	t telegram user	SQL	V202305241853__t_telegram_user.sql	-1479775329	doadmin	2023-06-09 01:17:57.656896	562	t
46	202305241905	t user	SQL	V202305241905__t_user.sql	-671861922	doadmin	2023-06-09 01:17:59.375875	564	t
47	202305251950	t user table	SQL	V202305251950__t_user_table.sql	280492850	doadmin	2023-06-09 01:18:00.998018	544	t
48	202305252010	t order	SQL	V202305252010__t_order.sql	-1700448255	doadmin	2023-06-09 01:18:02.597228	845	t
49	202305252121	t order meal	SQL	V202305252121__t_order_meal.sql	-1239226353	doadmin	2023-06-09 01:18:04.501126	816	t
50	202305271911	t waiter user	SQL	V202305271911__t_waiter_user.sql	541722668	doadmin	2023-06-09 01:18:06.369875	552	t
51	202306061745	t restaurant	SQL	V202306061745__t_restaurant.sql	221455666	doadmin	2023-06-09 01:18:07.970367	734	t
52	202306192037	t table session	SQL	V202306192037__t_table_session.sql	2136068760	doadmin	2023-07-10 13:56:47.612196	941	t
53	202306192102	t order	SQL	V202306192102__t_order.sql	-122597738	doadmin	2023-07-10 13:56:50.134982	980	t
54	202306211921	t table session	SQL	V202306211921__t_table_session.sql	-1543455028	doadmin	2023-07-10 13:56:52.556654	752	t
55	202306231926	t payment	SQL	V202306231926__t_payment.sql	-1206076050	doadmin	2023-07-10 13:56:54.750624	984	t
56	202306231940	t call waiter	SQL	V202306231940__t_call_waiter.sql	314620503	doadmin	2023-07-10 13:56:57.175633	738	t
57	202308121900	t payment	SQL	V202308121900__t_payment.sql	1144749804	doadmin	2023-08-28 15:40:26.787319	678	t
58	202308121930	t call waiter	SQL	V202308121930__t_call_waiter.sql	1592498730	doadmin	2023-08-28 15:40:28.692704	653	t
59	202309071630	t meal	SQL	V202309071630__t_meal.sql	-975923757	doadmin	2023-09-07 14:31:23.741761	730	t
60	202309071635	t meal	SQL	V202309071635__t_meal.sql	-547572966	doadmin	2023-09-07 14:31:26.071613	724	t
61	202310301721	t staff user	SQL	V202310301721__t_staff_user.sql	1091287031	doadmin	2023-11-04 13:52:09.720994	1428	t
62	202310301732	t staff user	SQL	V202310301732__t_staff_user.sql	-907632666	doadmin	2023-11-04 13:52:12.335069	528	t
63	202311182000	t staff user	SQL	V202311182000__t_staff_user.sql	-1714793170	doadmin	2023-11-18 17:27:40.858088	578	t
64	202312191400	t category	SQL	V202312191400__t_category.sql	484930515	doadmin	2023-12-19 12:36:36.268438	743	t
65	202312271817	t meal	SQL	V202312271817__t_meal.sql	-194560118	doadmin	2023-12-27 16:35:50.33465	952	t
66	202403241700	t restaurant details	SQL	V202403241700__t_restaurant_details.sql	-1417279788	doadmin	2024-03-25 16:27:48.962702	579	t
67	202403241710	t order item	SQL	V202403241710__t_order_item.sql	1208907441	doadmin	2024-03-25 16:27:50.745133	752	t
68	202403241720	t branch item	SQL	V202403241720__t_branch_item.sql	859629574	doadmin	2024-03-25 16:27:52.59923	1228	t
69	202403241730	t item localization	SQL	V202403241730__t_item_localization.sql	729885854	doadmin	2024-03-25 16:27:54.930353	658	t
70	202403241735	t category localization	SQL	V202403241735__t_category_localization.sql	1662880123	doadmin	2024-03-25 16:27:56.685072	561	t
71	202403241740	t order	SQL	V202403241740__t_order.sql	1877794599	doadmin	2024-03-25 16:27:58.344165	656	t
72	202403241750	t table	SQL	V202403241750__t_table.sql	43701774	doadmin	2024-03-25 16:28:00.095281	1129	t
73	202403241800	t branch	SQL	V202403241800__t_branch.sql	1700938006	doadmin	2024-03-25 16:28:02.320501	1037	t
74	202403241810	t user	SQL	V202403241810__t_user.sql	198270819	doadmin	2024-03-25 16:28:04.454443	1036	t
75	202403241820	t item	SQL	V202403241820__t_item.sql	196434464	doadmin	2024-03-25 16:28:06.58689	1792	t
76	202403241830	t category	SQL	V202403241830__t_category.sql	748194163	doadmin	2024-03-25 16:28:09.47512	563	t
77	202403241900	t call waiter	SQL	V202403241900__t_call_waiter.sql	75518704	doadmin	2024-03-25 16:28:11.131641	562	t
78	202403241910	t payment	SQL	V202403241910__t_payment.sql	-1237946086	doadmin	2024-03-25 16:28:12.788901	571	t
79	202403242100	t client	SQL	V202403242100__t_client.sql	1434891857	doadmin	2024-03-25 16:28:14.45239	586	t
80	202404061400	t client	SQL	V202404061400__t_client.sql	686660272	doadmin	2024-04-12 17:53:02.324661	747	t
81	202404061410	t branch	SQL	V202404061410__t_branch.sql	401505458	doadmin	2024-04-12 17:53:04.250265	631	t
82	202404061420	t user branch	SQL	V202404061420__t_user_branch.sql	1054215405	doadmin	2024-04-12 17:53:05.964931	636	t
83	202404061430	t user	SQL	V202404061430__t_user.sql	-1634864854	doadmin	2024-04-12 17:53:07.68331	626	t
84	202406041330	t category	SQL	V202406041330__t_category.sql	-1230037191	doadmin	2024-07-05 16:15:32.607177	1039	t
85	202408081700	t branch	SQL	V202408081700__t_branch.sql	1347157441	doadmin	2024-08-12 18:36:40.122269	735	t
86	202408171800	t item	SQL	V202408171800__t_item.sql	-1744802929	doadmin	2024-09-08 11:45:46.942066	1366	t
87	202409271557	t user	SQL	V202409271557__t_user.sql	1236368366	doadmin	2024-10-07 15:33:27.124697	1303	t
88	202410061800	t category	SQL	V202410061800__t_category.sql	50557576	doadmin	2024-10-14 13:56:13.089933	857	t
\.


--
-- Data for Name: t_branch; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_branch (id, name, uuid, client_id, address_line1, address_line2, city, postal_code, country_code) FROM stdin;
2	La Mamaliga	dc521baa-b59e-4fcd-a4e9-28a3e32b7015	2	Dummy Street Address	\N	\N	\N	MDA
3	Culinary Crossroads	c58ed205-a069-46e9-b703-23ab0a0ee26e	3	Dummy Street Address	\N	\N	\N	MDA
4	branches12	00386787-2fbc-42b6-8dcd-7d72868b9cf2	1	branchdasdeйцs12	branches1	branches1	branches1	123
1	Bratwursthaus	19890054-1ed0-41bc-b40b-626bd04fa6dc	1	Dummy	Al 2	Moldova	123	MDA
6	Balti	545809d5-3c4a-4632-b9d4-71839f0acec3	4	tba	\N	Balti	1	MDA
5	Alex's Branch123	5d6e3eba-702f-444f-91c5-f7fd98296c77	1	Matei Basarab 10/3		Bucuresti	MD-2045	MD
\.


--
-- Data for Name: t_branch_item; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_branch_item (branch_id, item_id, availability) FROM stdin;
6	664	AVAILABLE
6	685	AVAILABLE
1	34	AVAILABLE
1	31	HIDDEN
1	21	HIDDEN
1	30	HIDDEN
1	14	AVAILABLE
1	33	HIDDEN
1	32	HIDDEN
1	29	AVAILABLE
1	2	HIDDEN
4	449	HIDDEN
4	453	AVAILABLE
1	453	AVAILABLE
4	457	AVAILABLE
4	461	AVAILABLE
1	3	AVAILABLE
1	17	HIDDEN
1	27	AVAILABLE
1	26	AVAILABLE
1	15	HIDDEN
1	25	HIDDEN
1	18	AVAILABLE
1	20	AVAILABLE
1	449	HIDDEN
1	35	HIDDEN
1	461	HIDDEN
1	457	HIDDEN
2	4	AVAILABLE
2	6	AVAILABLE
2	7	AVAILABLE
2	8	AVAILABLE
4	463	AVAILABLE
5	463	AVAILABLE
1	463	AVAILABLE
6	649	AVAILABLE
6	650	AVAILABLE
6	651	AVAILABLE
6	652	AVAILABLE
6	653	AVAILABLE
6	654	AVAILABLE
6	655	AVAILABLE
6	656	AVAILABLE
6	657	AVAILABLE
6	658	AVAILABLE
6	659	AVAILABLE
6	660	AVAILABLE
3	387	AVAILABLE
6	661	AVAILABLE
6	662	AVAILABLE
3	388	AVAILABLE
3	389	AVAILABLE
3	390	AVAILABLE
3	391	AVAILABLE
3	392	AVAILABLE
3	393	AVAILABLE
3	394	AVAILABLE
6	663	AVAILABLE
1	115	AVAILABLE
1	116	AVAILABLE
1	117	AVAILABLE
1	119	AVAILABLE
1	120	AVAILABLE
1	121	AVAILABLE
1	122	AVAILABLE
2	5	HIDDEN
3	395	AVAILABLE
3	396	AVAILABLE
3	397	AVAILABLE
3	398	AVAILABLE
3	399	AVAILABLE
1	1	HIDDEN
6	665	AVAILABLE
6	666	AVAILABLE
6	667	AVAILABLE
6	668	AVAILABLE
6	669	AVAILABLE
6	670	AVAILABLE
6	671	AVAILABLE
6	672	AVAILABLE
6	673	AVAILABLE
6	674	AVAILABLE
6	675	AVAILABLE
6	676	AVAILABLE
6	677	AVAILABLE
6	678	AVAILABLE
6	679	AVAILABLE
6	680	AVAILABLE
6	681	AVAILABLE
6	682	AVAILABLE
6	683	AVAILABLE
6	684	AVAILABLE
6	686	AVAILABLE
6	687	AVAILABLE
6	688	AVAILABLE
6	689	AVAILABLE
6	690	AVAILABLE
6	691	AVAILABLE
6	692	AVAILABLE
6	693	AVAILABLE
6	694	AVAILABLE
6	695	AVAILABLE
6	696	AVAILABLE
6	697	AVAILABLE
6	698	AVAILABLE
6	699	AVAILABLE
6	700	AVAILABLE
6	701	AVAILABLE
6	702	AVAILABLE
6	703	AVAILABLE
6	704	AVAILABLE
3	400	AVAILABLE
3	401	AVAILABLE
3	402	AVAILABLE
3	403	AVAILABLE
3	404	AVAILABLE
3	405	AVAILABLE
3	406	AVAILABLE
3	407	AVAILABLE
3	408	AVAILABLE
3	409	AVAILABLE
3	410	AVAILABLE
3	411	AVAILABLE
3	412	AVAILABLE
3	413	AVAILABLE
3	414	AVAILABLE
3	415	AVAILABLE
3	416	AVAILABLE
3	417	AVAILABLE
3	418	AVAILABLE
3	419	AVAILABLE
3	420	AVAILABLE
3	421	AVAILABLE
3	422	AVAILABLE
3	423	AVAILABLE
3	424	AVAILABLE
3	425	AVAILABLE
3	426	AVAILABLE
3	427	AVAILABLE
3	428	AVAILABLE
3	429	AVAILABLE
3	430	AVAILABLE
3	431	AVAILABLE
3	432	AVAILABLE
3	433	AVAILABLE
3	434	AVAILABLE
3	435	AVAILABLE
3	436	AVAILABLE
3	437	AVAILABLE
3	438	AVAILABLE
3	439	AVAILABLE
3	440	AVAILABLE
3	441	AVAILABLE
3	442	AVAILABLE
3	443	AVAILABLE
3	444	AVAILABLE
3	445	AVAILABLE
3	446	AVAILABLE
3	447	AVAILABLE
3	448	AVAILABLE
4	450	AVAILABLE
4	458	AVAILABLE
1	458	HIDDEN
1	450	HIDDEN
4	464	AVAILABLE
5	464	AVAILABLE
1	464	AVAILABLE
6	705	AVAILABLE
6	706	AVAILABLE
6	707	AVAILABLE
6	708	AVAILABLE
6	709	AVAILABLE
6	710	AVAILABLE
6	711	AVAILABLE
6	712	AVAILABLE
6	713	AVAILABLE
6	714	AVAILABLE
6	715	AVAILABLE
6	716	AVAILABLE
6	717	AVAILABLE
6	718	AVAILABLE
6	719	AVAILABLE
6	720	AVAILABLE
6	721	AVAILABLE
6	722	AVAILABLE
6	723	AVAILABLE
6	724	AVAILABLE
6	725	AVAILABLE
6	726	AVAILABLE
6	727	AVAILABLE
6	728	AVAILABLE
6	729	AVAILABLE
6	730	AVAILABLE
6	731	AVAILABLE
6	732	AVAILABLE
6	733	AVAILABLE
6	734	AVAILABLE
4	735	AVAILABLE
5	735	AVAILABLE
1	735	AVAILABLE
4	736	AVAILABLE
5	736	AVAILABLE
1	736	AVAILABLE
4	737	AVAILABLE
5	737	AVAILABLE
1	737	AVAILABLE
4	738	AVAILABLE
5	738	AVAILABLE
1	738	AVAILABLE
4	739	AVAILABLE
5	739	AVAILABLE
1	739	AVAILABLE
4	740	AVAILABLE
5	740	AVAILABLE
1	740	AVAILABLE
\.


--
-- Data for Name: t_call_waiter; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_call_waiter (id, table_session_id, created_at, acknowledged_at, acknowledged_by) FROM stdin;
1	1	2023-07-14 23:46:59.562715	2023-08-28 16:02:02.403836	1
2	1	2023-07-14 23:47:06.961067	2023-08-28 16:02:02.403784	1
3	1	2023-07-14 23:47:07.824803	2023-08-28 16:02:02.403851	1
4	1	2023-07-14 23:47:08.217571	2023-08-28 16:02:02.40382	1
5	1	2023-07-14 23:47:08.444876	2023-08-28 16:02:02.403824	1
6	1	2023-07-14 23:47:08.626435	2023-08-28 16:02:02.403845	1
7	1	2023-07-14 23:47:08.793296	2023-08-28 16:02:02.403871	1
8	1	2023-07-14 23:47:34.845831	2023-08-28 16:02:02.403832	1
9	1	2023-07-26 10:58:20.519451	2023-08-28 16:02:02.403867	1
10	1	2023-07-28 00:38:49.609652	2023-08-28 16:02:02.403827	1
11	1	2023-07-28 03:10:30.466536	2023-08-28 16:02:02.403822	1
12	1	2023-08-01 09:35:33.111073	2023-08-28 16:02:02.403835	1
13	1	2023-08-01 10:52:48.993489	2023-08-28 16:02:02.403841	1
14	1	2023-08-01 11:06:56.170464	2023-08-28 16:02:02.403847	1
15	1	2023-08-01 11:27:02.097207	2023-08-28 16:02:02.403862	1
16	1	2023-08-03 10:31:13.314494	2023-08-28 16:02:02.403856	1
17	1	2023-08-03 11:04:39.773595	2023-08-28 16:02:02.403849	1
18	1	2023-08-03 15:30:36.340662	2023-08-28 16:02:02.403853	1
19	1	2023-08-14 14:31:57.403225	2023-08-28 16:02:02.403815	1
20	1	2023-08-14 14:33:59.225657	2023-08-28 16:02:02.403864	1
21	1	2023-08-27 12:26:26.322439	2023-08-28 16:02:02.403817	1
22	1	2023-08-27 13:28:30.21053	2023-08-28 16:02:02.403838	1
23	1	2023-08-28 15:48:54.255099	2023-08-28 16:02:02.403843	1
24	1	2023-08-29 15:12:17.572233	2023-08-30 17:18:20.282567	1
25	1	2023-08-30 17:07:54.776048	2023-08-30 17:18:20.282565	1
26	1	2023-08-30 17:08:02.270443	2023-08-30 17:18:20.282553	1
27	1	2023-08-30 17:19:02.862432	2023-08-30 17:19:07.260549	1
28	1	2023-08-31 10:13:35.645795	2023-08-31 11:24:44.473526	1
29	23	2023-08-31 12:00:12.574178	2023-08-31 12:00:21.987766	1
30	23	2023-08-31 12:00:32.185691	2023-08-31 12:05:25.005251	1
31	23	2023-08-31 12:12:23.280737	2023-08-31 12:14:32.298735	1
32	23	2023-08-31 13:18:48.655723	2023-08-31 13:18:58.795224	1
40	4	2023-09-19 22:12:51.994822	\N	\N
41	4	2023-09-19 22:18:25.92395	\N	\N
42	4	2023-09-19 22:44:32.914013	\N	\N
33	22	2023-09-01 15:11:44.726741	2023-09-29 14:51:52.336269	1
34	22	2023-09-01 15:12:02.289966	2023-09-29 14:51:52.336235	1
35	22	2023-09-07 10:30:46.304901	2023-09-29 14:51:52.336267	1
37	22	2023-09-07 13:11:59.059291	2023-09-29 14:51:52.336264	1
45	22	2023-09-26 11:38:06.853658	2023-09-29 14:51:52.336276	1
50	22	2023-10-13 16:06:11.204756	2023-10-22 12:26:28.609795	1
51	22	2023-10-13 16:07:09.339741	2023-10-22 12:26:28.609812	1
52	22	2023-10-13 16:09:51.815176	2023-10-22 12:26:28.609802	1
53	22	2023-10-13 16:17:41.497904	2023-10-22 12:26:28.6098	1
54	22	2023-10-13 16:26:24.322616	2023-10-22 12:26:28.609727	1
55	22	2023-10-13 16:27:33.272916	2023-10-22 12:26:28.609803	1
56	22	2023-10-13 16:42:49.628256	2023-10-22 12:26:28.609804	1
57	22	2023-10-13 16:43:37.533398	2023-10-22 12:26:28.609794	1
58	22	2023-10-13 16:44:02.094256	2023-10-22 12:26:28.60981	1
59	22	2023-10-13 17:36:11.312469	2023-10-22 12:26:28.609799	1
60	22	2023-10-13 17:43:32.555108	2023-10-22 12:26:28.609783	1
61	22	2023-10-13 17:44:12.61472	2023-10-22 12:26:28.609808	1
62	22	2023-10-13 18:08:56.283787	2023-10-22 12:26:28.609797	1
63	22	2023-10-14 08:22:58.097535	2023-10-22 12:26:28.609786	1
64	22	2023-10-14 08:24:50.146522	2023-10-22 12:26:28.609798	1
65	22	2023-10-14 08:25:46.351544	2023-10-22 12:26:28.609811	1
66	22	2023-10-14 08:26:08.379385	2023-10-22 12:26:28.609807	1
67	22	2023-10-14 08:27:31.690634	2023-10-22 12:26:28.609789	1
68	22	2023-10-14 08:32:35.082385	2023-10-22 12:26:28.609788	1
69	22	2023-10-14 08:33:12.872812	2023-10-22 12:26:28.609813	1
70	22	2023-10-14 08:40:11.203336	2023-10-22 12:26:28.609785	1
71	22	2023-10-14 09:12:52.812843	2023-10-22 12:26:28.609806	1
49	26	2023-10-05 11:37:21.532072	2023-10-24 10:41:41.892984	1
48	26	2023-10-05 11:35:54.006935	2023-10-24 10:41:41.892988	1
47	26	2023-10-05 11:32:24.413938	2023-10-24 10:41:41.892989	1
46	26	2023-10-04 11:42:30.85951	2023-10-24 10:41:41.892986	1
39	26	2023-09-16 13:14:27.167022	2023-10-24 10:41:41.892982	1
38	26	2023-09-11 17:47:57.761593	2023-10-24 10:41:41.892991	1
36	26	2023-09-07 13:09:06.95694	2023-10-24 10:41:41.892961	1
72	3	2023-10-24 10:45:58.668923	2023-10-24 10:46:57.11895	1
44	31	2023-09-20 22:14:52.072788	2023-10-24 21:27:09.019783	2
43	31	2023-09-20 21:20:07.98857	2023-10-24 21:27:09.019805	2
74	36	2023-10-28 18:09:26.628275	2023-10-28 18:10:02.041657	2
73	36	2023-10-28 18:09:26.49399	2023-10-28 18:10:02.041661	2
75	30	2023-11-19 21:03:02.111632	2023-11-19 21:12:30.283366	1
76	30	2023-11-19 21:03:37.489731	2023-11-19 21:12:30.283378	1
77	30	2023-11-19 21:05:05.051099	2023-11-19 21:12:30.283376	1
78	30	2023-11-19 21:13:08.877036	2023-11-19 21:13:21.950371	1
79	49	2023-11-19 21:18:45.836263	2023-11-19 21:18:53.328727	1
80	39	2023-11-29 15:28:32.442814	2023-11-29 15:28:45.760978	1
81	6	2023-11-30 17:40:02.004215	2023-11-30 17:40:36.427778	5
82	6	2023-11-30 17:40:55.910374	2023-11-30 17:41:01.223803	2
83	39	2023-12-01 05:45:58.026771	2023-12-01 05:46:07.345747	1
84	39	2023-12-01 08:42:41.455178	2023-12-01 08:47:12.172729	1
85	39	2023-12-01 08:43:03.34322	2023-12-01 08:47:12.172706	1
86	74	2023-12-05 18:12:34.538305	2023-12-05 18:13:08.602471	2
87	59	2023-12-05 21:03:34.35585	2023-12-05 21:04:31.165068	3
88	80	2023-12-06 18:06:58.366495	2023-12-06 18:08:02.550462	3
89	74	2023-12-06 18:30:36.195226	2023-12-19 22:43:39.702153	3
90	92	2023-12-19 23:27:42.331235	2023-12-20 07:48:53.917978	3
91	22	2023-12-20 07:49:03.367484	\N	\N
92	93	2023-12-21 05:08:49.682233	2023-12-23 08:21:14.930595	2
93	82	2023-12-23 08:41:06.653343	2023-12-23 08:41:11.683003	2
94	93	2023-12-23 08:42:57.32469	2023-12-23 08:42:59.879847	2
95	93	2023-12-25 10:12:41.500597	\N	\N
96	103	2023-12-25 10:34:25.25338	2023-12-25 10:35:16.374553	2
97	103	2023-12-25 10:35:38.229	2023-12-25 11:55:34.853598	2
99	82	2023-12-28 19:12:12.701087	2023-12-28 19:12:54.583259	7
100	82	2023-12-28 19:13:00.599092	\N	\N
101	82	2023-12-28 19:13:01.254455	\N	\N
103	105	2024-03-04 22:28:46.24734	2024-03-17 13:04:39.616977	2
119	109	2024-03-19 14:10:00.453582	2024-03-20 21:03:37.189025	12
98	31	2023-12-26 14:04:51.044616	2024-04-14 23:26:50.248498	5
104	108	2024-03-12 20:23:07.234103	2024-04-14 23:37:54.423863	12
120	105	2024-03-22 00:03:43.598927	2024-03-22 10:04:13.291035	1
121	5	2024-03-22 10:11:44.010768	2024-03-22 10:11:55.020982	1
122	5	2024-03-22 10:21:57.589754	2024-03-22 10:23:06.113852	1
123	5	2024-03-22 10:21:58.218194	2024-03-22 10:23:06.11384	1
124	5	2024-03-22 10:24:23.480229	2024-03-22 10:24:46.953256	1
125	5	2024-03-22 10:24:34.364915	2024-03-22 10:24:46.95326	1
126	5	2024-03-25 16:36:18.559567	2024-04-03 15:07:47.946599	1
127	5	2024-03-25 21:11:02.73603	2024-04-03 15:07:47.946614	1
143	163	2024-04-04 10:01:20.638583	2024-04-04 10:01:22.089219	13
144	167	2024-04-04 10:01:54.914663	2024-04-04 10:01:56.366436	13
145	175	2024-04-04 10:06:10.200382	2024-04-04 10:06:11.624112	13
146	181	2024-04-05 10:43:16.676448	2024-04-05 10:44:44.682496	13
147	200	2024-04-05 11:24:19.633955	2024-04-05 11:24:20.979797	13
148	202	2024-04-05 11:24:29.703395	2024-04-05 11:24:31.096651	13
149	221	2024-04-08 07:34:31.631586	2024-04-08 07:34:33.160548	13
150	223	2024-04-08 07:34:42.431597	2024-04-08 07:34:43.767263	13
151	250	2024-04-08 07:44:36.065443	\N	\N
152	281	2024-04-08 07:45:56.49911	\N	\N
153	294	2024-04-08 08:12:20.668877	2024-04-08 08:12:21.351738	13
154	296	2024-04-08 08:12:25.134525	2024-04-08 08:12:25.661371	13
155	317	2024-04-08 08:23:57.594757	2024-04-08 08:23:58.312872	13
156	319	2024-04-08 08:24:02.397778	2024-04-08 08:24:02.980302	13
157	336	2024-04-08 08:26:30.10186	2024-04-08 08:26:30.78436	13
158	338	2024-04-08 08:26:34.616317	2024-04-08 08:26:35.142032	13
159	357	2024-04-08 08:27:55.013961	2024-04-08 08:27:56.060479	13
160	359	2024-04-08 08:28:02.028731	2024-04-08 08:28:02.937227	13
161	380	2024-04-08 08:57:20.657247	2024-04-08 08:57:21.329981	13
162	382	2024-04-08 08:57:25.175179	2024-04-08 08:57:25.727578	13
163	399	2024-04-08 09:07:22.56516	2024-04-08 09:07:23.610629	13
164	401	2024-04-08 09:07:29.593515	2024-04-08 09:07:30.475438	13
165	420	2024-04-08 09:09:24.324534	2024-04-08 09:09:25.235392	13
166	422	2024-04-08 09:09:30.618612	2024-04-08 09:09:31.415869	13
167	441	2024-04-08 09:12:46.412746	2024-04-08 09:12:47.431068	13
168	443	2024-04-08 09:12:53.381692	2024-04-08 09:12:54.266972	13
169	464	2024-04-08 09:35:54.051675	2024-04-08 09:35:55.273936	13
170	466	2024-04-08 09:36:02.032826	2024-04-08 09:36:03.039287	13
171	483	2024-04-09 09:08:48.932333	2024-04-09 09:08:50.287605	13
172	485	2024-04-09 09:08:57.337625	2024-04-09 09:08:58.320599	13
173	510	2024-04-09 09:43:32.656527	2024-04-09 09:43:34.241067	13
174	512	2024-04-09 09:43:43.965768	2024-04-09 09:43:45.382882	13
175	534	2024-04-09 10:25:42.357077	2024-04-09 10:25:43.930519	13
176	536	2024-04-09 10:25:53.00418	2024-04-09 10:25:54.324376	13
177	563	2024-04-09 10:45:05.397292	2024-04-09 10:45:06.780063	13
178	578	2024-04-09 10:46:49.613321	2024-04-09 10:46:51.009458	13
179	582	2024-04-09 10:47:55.928807	2024-04-09 10:47:57.763692	13
180	584	2024-04-09 10:48:07.089143	2024-04-09 10:48:08.594124	13
181	601	2024-04-09 11:01:07.004874	2024-04-09 11:01:08.863995	13
182	603	2024-04-09 11:01:18.023988	2024-04-09 11:01:19.415995	13
183	620	2024-04-09 11:11:55.28626	2024-04-09 11:11:56.822808	13
184	622	2024-04-09 11:12:08.669824	2024-04-09 11:12:10.053886	13
185	639	2024-04-09 11:36:02.750335	2024-04-09 11:36:04.259656	13
186	641	2024-04-09 11:36:13.511342	2024-04-09 11:36:14.84193	13
187	660	2024-04-09 11:41:24.945381	2024-04-09 11:41:25.63925	13
188	662	2024-04-09 11:41:29.496002	2024-04-09 11:41:30.039187	13
189	682	2024-04-09 12:03:38.889544	\N	\N
190	708	2024-04-09 12:08:06.483514	2024-04-09 12:08:07.968594	13
191	710	2024-04-09 12:08:17.25116	2024-04-09 12:08:18.590953	13
192	729	2024-04-09 12:12:38.875298	2024-04-09 12:12:40.350844	13
193	731	2024-04-09 12:12:49.595138	2024-04-09 12:12:50.931219	13
194	750	2024-04-09 12:18:14.786619	2024-04-09 12:18:15.528515	13
195	752	2024-04-09 12:18:19.614202	2024-04-09 12:18:20.192533	13
196	771	2024-04-09 12:19:59.487819	2024-04-09 12:20:00.360946	13
197	773	2024-04-09 12:20:05.298426	2024-04-09 12:20:05.971921	13
198	792	2024-04-10 02:26:14.611391	2024-04-10 02:26:15.386018	13
199	794	2024-04-10 02:26:19.464493	2024-04-10 02:26:20.033839	13
201	815	2024-04-10 10:56:40.844064	2024-04-10 10:56:41.570831	13
202	817	2024-04-10 10:56:45.539996	2024-04-10 10:56:46.076154	13
203	836	2024-04-10 11:00:12.666561	2024-04-10 11:00:13.420406	13
204	838	2024-04-10 11:00:17.525067	2024-04-10 11:00:18.090898	13
205	857	2024-04-10 11:01:26.862248	2024-04-10 11:01:27.619281	13
206	859	2024-04-10 11:01:31.725578	2024-04-10 11:01:32.284247	13
207	878	2024-04-10 11:06:04.806633	2024-04-10 11:06:05.633764	13
208	880	2024-04-10 11:06:10.198595	2024-04-10 11:06:10.838468	13
209	899	2024-04-10 11:08:35.628764	2024-04-10 11:08:36.449261	13
210	901	2024-04-10 11:08:40.999911	2024-04-10 11:08:41.637853	13
211	920	2024-04-10 11:12:36.676773	2024-04-10 11:12:37.748946	13
212	922	2024-04-10 11:12:44.01629	2024-04-10 11:12:44.912956	13
213	941	2024-04-10 11:19:30.81427	2024-04-10 11:19:32.09911	13
214	943	2024-04-10 11:19:38.078975	2024-04-10 11:19:38.895049	13
215	962	2024-04-12 18:36:32.202754	2024-04-12 18:36:33.348982	13
216	964	2024-04-12 18:36:39.293652	2024-04-12 18:36:40.08971	13
102	31	2023-12-28 22:03:01.438526	2024-04-14 23:26:50.248501	5
217	981	2024-04-14 23:33:23.8358	2024-04-14 23:33:33.288665	2
218	981	2024-04-14 23:33:38.448848	2024-04-14 23:33:49.334417	5
105	108	2024-03-12 20:24:23.006867	2024-04-14 23:37:54.42393	12
106	108	2024-03-12 20:24:23.593365	2024-04-14 23:37:54.423943	12
107	108	2024-03-12 20:37:26.784265	2024-04-14 23:37:54.423917	12
108	108	2024-03-17 11:37:18.537682	2024-04-14 23:37:54.423938	12
109	108	2024-03-17 13:30:46.610711	2024-04-14 23:37:54.423911	12
110	108	2024-03-18 17:12:17.234596	2024-04-14 23:37:54.423925	12
111	108	2024-03-18 17:13:11.690044	2024-04-14 23:37:54.423914	12
112	108	2024-03-18 17:13:52.375548	2024-04-14 23:37:54.423935	12
113	108	2024-03-18 17:24:51.20498	2024-04-14 23:37:54.423957	12
114	108	2024-03-18 18:46:25.144444	2024-04-14 23:37:54.423927	12
115	108	2024-03-18 18:52:29.138318	2024-04-14 23:37:54.423951	12
116	108	2024-03-18 18:52:40.604088	2024-04-14 23:37:54.423946	12
117	108	2024-03-18 19:28:27.784818	2024-04-14 23:37:54.423949	12
118	108	2024-03-19 08:06:24.545806	2024-04-14 23:37:54.423958	12
128	108	2024-03-25 22:45:13.059991	2024-04-14 23:37:54.423856	12
129	108	2024-03-29 09:46:13.197693	2024-04-14 23:37:54.423963	12
130	108	2024-03-29 09:46:21.90356	2024-04-14 23:37:54.423932	12
131	108	2024-03-29 09:53:09.888006	2024-04-14 23:37:54.423934	12
132	108	2024-03-29 09:55:02.985832	2024-04-14 23:37:54.423912	12
133	108	2024-03-31 21:17:18.407931	2024-04-14 23:37:54.42392	12
134	108	2024-04-02 21:32:30.800244	2024-04-14 23:37:54.423866	12
135	108	2024-04-02 21:34:29.897133	2024-04-14 23:37:54.423861	12
136	108	2024-04-02 21:55:58.906953	2024-04-14 23:37:54.423952	12
137	108	2024-04-02 23:13:07.616759	2024-04-14 23:37:54.423843	12
138	108	2024-04-02 23:16:20.0045	2024-04-14 23:37:54.423948	12
139	108	2024-04-03 10:23:51.4725	2024-04-14 23:37:54.423961	12
140	108	2024-04-03 10:25:45.01547	2024-04-14 23:37:54.42396	12
141	108	2024-04-03 10:31:29.760646	2024-04-14 23:37:54.423955	12
142	108	2024-04-03 16:39:17.264556	2024-04-14 23:37:54.423916	12
200	108	2024-04-10 10:32:45.018789	2024-04-14 23:37:54.423923	12
219	122	2024-04-15 22:37:01.370991	\N	\N
220	984	2024-04-22 15:27:18.764548	2024-04-22 15:27:19.596682	13
221	986	2024-04-22 15:27:23.855558	2024-04-22 15:27:24.436663	13
222	1005	2024-04-23 02:13:50.237431	2024-04-23 02:13:51.456473	13
223	1007	2024-04-23 02:13:57.463383	2024-04-23 02:13:58.298208	13
224	1026	2024-04-23 18:16:12.105139	2024-04-23 18:16:13.405753	13
225	1028	2024-04-23 18:16:20.334544	2024-04-23 18:16:21.320542	13
226	1047	2024-04-23 19:00:28.830356	2024-04-23 19:00:30.224373	13
227	1049	2024-04-23 19:00:36.251565	2024-04-23 19:00:37.090363	13
228	1070	2024-06-16 07:21:17.506855	2024-06-16 07:21:18.817061	13
229	1072	2024-06-16 07:21:25.663336	2024-06-16 07:21:26.615447	13
230	1091	2024-07-05 16:16:50.598226	2024-07-05 16:16:51.833508	13
231	1093	2024-07-05 16:16:57.310016	2024-07-05 16:16:57.996214	13
232	1110	2024-07-18 19:28:39.117296	2024-07-18 19:28:40.642325	13
233	1112	2024-07-18 19:28:48.372944	2024-07-18 19:28:49.444209	13
234	1131	2024-07-19 07:24:54.371152	2024-07-19 07:24:55.958727	13
235	1133	2024-07-19 07:25:03.11887	2024-07-19 07:25:04.077196	13
236	1152	2024-08-01 14:29:35.402371	2024-08-01 14:29:36.372702	13
237	1154	2024-08-01 14:29:41.466499	2024-08-01 14:29:42.164562	13
238	1175	2024-08-01 14:34:54.692469	2024-08-01 14:34:55.815388	13
239	1177	2024-08-01 14:35:02.458532	2024-08-01 14:35:03.421564	13
240	1194	2024-08-01 14:40:00.309812	2024-08-01 14:40:01.239389	13
241	1196	2024-08-01 14:40:06.481201	2024-08-01 14:40:07.179612	13
242	1215	2024-08-01 15:14:56.528337	2024-08-01 15:14:57.50361	13
243	1217	2024-08-01 15:15:02.959264	2024-08-01 15:15:03.721675	13
244	117	2024-08-06 15:23:09.391534	\N	\N
245	1240	2024-08-19 10:25:07.173017	2024-08-19 10:25:08.676829	13
246	1242	2024-08-19 10:25:17.426689	2024-08-19 10:25:18.762099	13
247	1263	2024-08-19 10:28:30.3373	2024-08-19 10:28:31.213338	13
248	1265	2024-08-19 10:28:35.890185	2024-08-19 10:28:36.563926	13
249	1284	2024-08-20 09:54:57.547466	2024-08-20 09:54:58.671607	13
250	1286	2024-08-20 09:55:05.070486	2024-08-20 09:55:05.983583	13
251	1305	2024-08-20 15:09:08.674116	2024-08-20 15:09:09.441784	13
252	1307	2024-08-20 15:09:13.566047	2024-08-20 15:09:14.118882	13
253	1326	2024-08-28 13:54:33.533248	2024-08-28 13:54:34.458161	13
254	1328	2024-08-28 13:54:39.448715	2024-08-28 13:54:40.139928	13
255	1347	2024-08-28 17:04:29.493275	2024-08-28 17:04:30.480671	13
256	1349	2024-08-28 17:04:35.805476	2024-08-28 17:04:36.561107	13
257	1368	2024-09-02 14:29:55.474049	2024-09-02 14:29:57.136808	13
258	1370	2024-09-02 14:30:04.016273	2024-09-02 14:30:04.948457	13
259	1389	2024-09-04 19:34:24.361146	2024-09-04 19:34:25.269308	13
260	1391	2024-09-04 19:34:29.860577	2024-09-04 19:34:30.564366	13
261	1410	2024-09-04 20:04:03.027884	2024-09-04 20:04:03.936339	13
262	1412	2024-09-04 20:04:08.340004	2024-09-04 20:04:08.942052	13
263	1431	2024-09-08 11:46:51.716949	2024-09-08 11:46:52.9057	13
264	1433	2024-09-08 11:46:59.544929	2024-09-08 11:47:00.492095	13
265	1452	2024-09-08 12:03:15.977181	2024-09-08 12:03:16.771858	13
266	1454	2024-09-08 12:03:21.081916	2024-09-08 12:03:21.682458	13
267	1473	2024-09-08 12:07:41.162742	2024-09-08 12:07:42.672748	13
268	1475	2024-09-08 12:07:48.727654	2024-09-08 12:07:49.441877	13
269	1494	2024-09-08 12:21:36.060905	2024-09-08 12:21:37.32443	13
270	1496	2024-09-08 12:21:44.778021	2024-09-08 12:21:45.799488	13
271	1515	2024-09-15 17:05:10.736159	2024-09-15 17:05:11.569577	13
272	1517	2024-09-15 17:05:15.958764	2024-09-15 17:05:16.563928	13
273	107	2024-09-17 10:20:21.402094	2024-09-17 10:20:37.603693	1
274	1536	2024-09-18 20:09:43.44809	2024-09-18 20:09:44.546926	13
275	1538	2024-09-18 20:09:50.122319	2024-09-18 20:09:50.927905	13
276	1557	2024-09-18 20:11:13.16645	2024-09-18 20:11:14.09	13
277	1559	2024-09-18 20:11:18.542092	2024-09-18 20:11:19.133516	13
278	1576	2024-09-18 20:32:35.385796	2024-09-18 20:32:36.57269	13
279	1578	2024-09-18 20:32:43.190514	2024-09-18 20:32:44.153632	13
280	1597	2024-09-19 17:58:47.010113	2024-09-19 17:58:47.954523	13
281	1599	2024-09-19 17:58:58.61345	2024-09-19 17:58:59.335623	13
282	1618	2024-09-19 18:22:15.994382	2024-09-19 18:22:17.174331	13
283	1620	2024-09-19 18:22:23.669684	2024-09-19 18:22:24.60527	13
284	1639	2024-09-19 18:35:29.976187	2024-09-19 18:35:31.151639	13
285	1641	2024-09-19 18:35:37.94919	2024-09-19 18:35:38.83496	13
286	1660	2024-09-19 18:38:40.218488	2024-09-19 18:38:41.212659	13
287	1662	2024-09-19 18:38:45.700236	2024-09-19 18:38:46.295446	13
288	1681	2024-09-20 11:45:22.895121	2024-09-20 11:45:23.791261	13
289	1683	2024-09-20 11:45:28.158841	2024-09-20 11:45:28.774274	13
290	1702	2024-09-22 13:09:43.025651	2024-09-22 13:09:43.871728	13
291	1704	2024-09-22 13:09:48.304617	2024-09-22 13:09:48.900235	13
292	1723	2024-10-07 15:34:35.060228	2024-10-07 15:34:35.884725	13
293	1725	2024-10-07 15:34:40.063612	2024-10-07 15:34:40.669167	13
294	1746	2024-10-11 09:29:47.704613	2024-10-11 09:29:48.823947	13
295	1748	2024-10-11 09:29:55.090895	2024-10-11 09:29:55.994156	13
296	1767	2024-10-14 13:15:57.627329	2024-10-14 13:15:58.794939	13
297	1769	2024-10-14 13:16:05.477757	2024-10-14 13:16:06.449751	13
298	1788	2024-10-14 13:57:09.332785	2024-10-14 13:57:10.175215	13
299	1790	2024-10-14 13:57:14.572426	2024-10-14 13:57:15.154877	13
300	1809	2024-10-14 13:59:22.994086	2024-10-14 13:59:23.891518	13
301	1811	2024-10-14 13:59:28.160727	2024-10-14 13:59:28.763597	13
302	1828	2024-10-17 17:30:09.894154	2024-10-17 17:30:11.264818	13
303	1830	2024-10-17 17:30:16.975868	2024-10-17 17:30:17.73146	13
304	1851	2024-10-17 17:31:20.761724	2024-10-17 17:31:21.950501	13
305	1853	2024-10-17 17:31:28.738543	2024-10-17 17:31:29.749594	13
306	1872	2024-10-22 12:24:14.359261	2024-10-22 12:24:15.286474	13
307	1874	2024-10-22 12:24:19.785064	2024-10-22 12:24:20.34958	13
308	1893	2024-10-22 12:43:38.406938	2024-10-22 12:43:39.229537	13
309	1895	2024-10-22 12:43:43.592606	2024-10-22 12:43:44.206479	13
310	1914	2024-10-22 13:10:29.948026	2024-10-22 13:10:30.86928	13
311	1916	2024-10-22 13:10:35.121519	2024-10-22 13:10:35.728815	13
312	1935	2024-10-22 13:16:07.864342	2024-10-22 13:16:09.064975	13
313	1937	2024-10-22 13:16:15.577398	2024-10-22 13:16:16.505802	13
314	1956	2024-10-22 13:18:26.081473	2024-10-22 13:18:27.185436	13
315	1958	2024-10-22 13:18:32.027789	2024-10-22 13:18:32.704903	13
316	1977	2024-10-22 13:22:50.061758	2024-10-22 13:22:51.216743	13
317	1979	2024-10-22 13:22:57.680369	2024-10-22 13:22:58.600529	13
318	1998	2024-10-22 18:35:08.106618	2024-10-22 18:35:09.025411	13
319	2000	2024-10-22 18:35:13.673104	2024-10-22 18:35:14.295193	13
320	2019	2024-10-22 18:37:06.648592	2024-10-22 18:37:07.993306	13
321	2021	2024-10-22 18:37:14.564434	2024-10-22 18:37:15.519081	13
322	2040	2024-10-22 18:38:45.692562	2024-10-22 18:38:46.654796	13
323	2042	2024-10-22 18:38:51.148827	2024-10-22 18:38:51.727225	13
324	2061	2024-10-27 12:06:36.450902	2024-10-27 12:06:37.62727	13
325	2063	2024-10-27 12:06:43.968053	2024-10-27 12:06:44.881843	13
326	2082	2024-10-27 12:21:47.36177	2024-10-27 12:21:48.244006	13
327	2084	2024-10-27 12:21:53.010946	2024-10-27 12:21:53.696064	13
328	2113	2024-10-29 12:09:53.555061	2024-10-29 12:09:54.740063	13
329	2115	2024-10-29 12:10:01.28894	2024-10-29 12:10:02.312508	13
330	2134	2024-10-30 18:22:23.808981	2024-10-30 18:22:24.664339	13
331	2136	2024-10-30 18:22:28.974537	2024-10-30 18:22:29.610891	13
332	111	2025-02-11 18:29:12.172586	2025-02-11 18:29:25.05774	11
333	111	2025-02-11 18:30:09.989492	2025-02-11 18:32:14.334525	11
334	111	2025-02-11 18:31:45.415243	2025-02-11 18:32:14.334527	11
335	111	2025-02-11 18:32:09.051511	2025-02-11 18:32:14.334513	11
\.


--
-- Data for Name: t_category; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_category (id, sequence, default_name, client_id, show_images, uuid, deleted_at) FROM stdin;
4	1	Fripturi	2	f	a5375b23-207f-4f14-b95e-35cbdb4d5238	\N
7	2	Mâncăruri naționale	2	f	a87964a8-377d-47b0-894b-10d7706ea4b5	\N
5	4	Băuturi alcoolice	2	f	ef13c0d1-7ce2-4150-b479-9f4f4b455dda	\N
6	5	Băuturi nealcoolice	2	f	5bd7ac09-3c28-45b2-9bdf-f55102f5096d	\N
65	4	Паста	4	f	15a1206b-f11f-4fb6-a82b-4bd119395099	\N
67	6	Пицца	4	f	379f6f19-cd6c-44b4-a052-abad3484f18b	\N
75	37	fds	1	t	0a7b7fd5-35ff-40b2-8c50-797773c31baf	2024-10-29 11:13:11.051806
76	37	gfd	1	t	1079e3c0-97dd-4947-8031-23ef600f4935	2024-10-29 11:15:04.931056
77	37	number one	1	t	90c308b9-9d02-4d91-afc3-7025ec154ec9	2024-10-29 11:15:22.421592
1	0	Warm food	1	f	37e939a7-fe7a-4f05-87ad-1209b457e176	\N
78	37	tretretre	1	t	202e6a68-dd06-46bb-a2c8-3ffe345e1762	2024-10-29 11:34:24.08021
9	1	Dima Uniq	1	f	c3fb2fae-60fe-4477-82a9-52de5f5d350b	\N
51	31	Appetizers	1	t	3a7584d3-0a09-4c36-8d39-e675aa985ed8	2024-10-30 18:50:38.400098
28	8	Japanese Cuisine	1	t	845defdf-d67b-4779-bad5-06a11e5650c3	\N
29	9	Mediterranean Cuisine	1	t	3499c15b-fde7-4fa3-9345-5e6d05080fd5	\N
44	24	Italian Cuisine	1	t	aa190364-43eb-4a74-891d-533ba1b13d32	2024-10-31 14:53:22.169474
46	26	Japanese Cuisine	1	t	2f6b4718-b6c7-473e-83fe-698d2a19d0c5	2024-10-31 14:53:25.160126
52	32	Salads	1	t	f247eb88-1eeb-4c0c-b729-7541fa3708ff	2024-10-31 14:53:28.576476
10	2	Category 6	1	f	1425c0bc-331a-44b8-8e1f-7b592e1b16bb	2024-10-20 19:46:34.460124
37	17	Seafood Specials	1	f	3b7ba53e-5a70-47ec-9200-a732828658d1	\N
38	18	Italian Cuisine	1	f	eb202908-5851-4cdb-acda-62b181273512	\N
26	6	Italian Cuisine	1	t	b1f89d13-171b-4b84-8d22-a9fe51404c28	\N
32	12	Italian Cuisine	1	t	36a3e268-ea5d-4840-8814-519f4b5161b9	\N
57	1	Appetizers	3	t	77cf7c5f-8bac-4350-9f3f-976ae19241da	\N
58	2	Salads	3	t	8a3f9d72-ee49-4ae7-a97e-18e779bd1095	\N
59	3	Meat	3	t	3eb26ea5-bbf6-4efa-9de4-8e57b3fd43db	\N
60	4	Desserts	3	t	b083b18f-8bbb-4eac-8a05-8e3817c07fa0	\N
61	5	Drinks	3	t	5bfc40da-5be3-4d5b-8c6b-a33d59ff1f06	\N
62	6	Pasta	3	f	8c027566-4699-42c1-a393-8314db43f86f	\N
34	14	Japanese Cuisine	1	t	3c82b1e6-fa0e-4807-a081-34cbbd63391b	\N
35	15	Mediterranean Cuisine	1	t	e96bcf7b-458a-4b4e-8324-4ebcc9fc71e9	\N
36	16	Vegan Dishes	1	f	6b5e0181-fff1-4ffe-b633-4b9ec4fe05d0	\N
39	19	Mexican Cuisine	1	f	f2516c27-bcd3-4530-ab1c-036dad675fdd	\N
40	20	Japanese Cuisine	1	t	2df41803-792b-40bb-b9ad-c23c1b379511	\N
41	21	Mediterranean Cuisine	1	t	072f5209-6e62-47e5-85c6-ae59f98dd4fe	\N
42	22	Vegan Dishes	1	f	fc54c6a0-1a58-445e-b0b7-391fa18578d8	\N
43	23	Seafood Specials	1	f	f1ebe79b-911a-4ab9-81e7-819c9280878b	\N
45	25	Mexican Cuisine	1	f	b2f98901-ad16-428f-8e89-e0bd8c00a277	\N
47	27	Mediterranean Cuisine	1	t	96949589-dae1-42e7-8347-e01a78dee877	\N
48	28	Vegan Dishes	1	f	8c51e92f-ffce-4afc-a2b8-a2f3774a8bb6	\N
49	29	Seafood Specials	1	f	49cd31d6-f583-4e1e-822a-65872b67421c	\N
50	30	Italian Cuisine 2	1	t	1ce6f4a5-2beb-4528-bafb-ce948586a793	\N
53	33	Meat	1	t	597758b2-9c0f-43b9-b65c-3dc8b35715e6	\N
54	34	Desserts	1	t	71849509-b0a5-4084-86bc-3a32228c23ed	\N
55	35	Drinks	1	t	1744743d-226d-41f9-83a6-dad9443ec6d6	\N
56	36	Pasta	1	f	130a52a9-84dd-454a-acd1-e09961e8eb6b	\N
2	3	Appetizers	1	t	3a856122-f7e9-4ce0-932c-b8a78e4188cd	\N
74	1	Закуски	4	f	cd04e5b1-5963-4dab-8bb9-aa0cf60b45be	\N
63	0	Завтраки	4	f	fd60e972-1f1e-4126-8645-89a8b797b0a1	\N
73	3	Горячее	4	f	1248a29d-6678-49ce-80b0-a4f1bcd076da	\N
66	5	Салаты	4	f	f1227ccf-5cae-4553-9fea-eaee822a74c8	\N
64	2	Горячие закуски	4	f	fe885ebc-f173-41d7-82e4-863e70eea37b	\N
68	7	Соусы	4	f	29582045-1e2d-4a8e-a926-5e5058d92fd0	\N
69	8	Гарниры	4	f	6a927727-9523-414b-b7ee-bf66b699ec03	\N
70	9	Супы	4	f	39b711b5-69d8-4088-8674-e13956abc4d5	\N
71	10	Для пива	4	f	23fcc340-e490-480c-b238-25f503deb888	\N
72	11	Десерты	4	f	94fc7de9-219f-4976-a4b1-3d08d43b702b	\N
8	4	Category 4	1	t	3f1503a2-ff63-4d12-a227-02fdc38db25c	\N
11	5	Category 7	1	t	2b893027-1b25-4dd7-a8ed-c28c5e459157	\N
27	7	Mexican Cuisine	1	t	2daf53d2-a3bc-405c-9d25-9dacab80d8ad	\N
30	10	Vegan Dishes	1	t	ad0b4695-af7e-4e1e-b8b4-1196486734f5	\N
31	11	Seafood Specials	1	t	39bb9556-82b5-412d-9203-d6cb4a7265ec	\N
33	13	Mexican Cuisine	1	t	19e3ef7f-3216-42b6-8026-dad4a7c5e41b	\N
3	2	Drinks	1	t	f5667355-1147-4f02-89fd-8a972f8667e8	\N
\.


--
-- Data for Name: t_category_localization; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_category_localization (category_id, localization, name) FROM stdin;
1	de	Warme Speisen
1	en	Warm food
2	en	Appetizers
2	de	Vorspeisen
3	en	Drinks
3	de	Getränke
4	ro	Fripturi
4	en	Steaks
5	en	Alcohol drinks
5	ro	Băuturi alcoolice
6	ro	Băuturi nealcoolice
6	en	Non alcoholic drinks
7	ro	Mâncăruri naționale
7	en	National dishes
26	de	Italienische Küche
26	ro	Bucatarie italiana
27	de	Mexikanische Küche
27	ro	Bucătărie mexicană
28	de	Japanische Küche
28	ro	Bucataria japoneza
29	de	Mediterrane Küche
29	ro	Bucătărie mediteraneană
30	de	Vegane Gerichte
30	ro	Mâncăruri vegane
31	de	Meeresfrüchte-Spezialitäten
31	ro	Speciale fructe de mare
32	de	Italienische Küche
32	ro	Bucatarie italiana
33	de	Mexikanische Küche
33	ro	Bucătărie mexicană
34	de	Japanische Küche
34	ro	Bucataria japoneza
35	de	Mediterrane Küche
35	ro	Bucătărie mediteraneană
36	de	Vegane Gerichte
36	ro	Mâncăruri vegane
37	de	Meeresfrüchte-Spezialitäten
37	ro	Speciale fructe de mare
38	de	Italienische Küche
38	ro	Bucatarie italianaå
39	de	Mexikanische Küche
39	ro	Bucătărie mexicană
40	de	Japanische Küche
40	ro	Bucataria japoneza
41	de	Mediterrane Küche
41	ro	Bucătărie mediteraneană
42	de	Vegane Gerichte
42	ro	Mâncăruri vegane
43	de	Meeresfrüchte-Spezialitäten
43	ro	Speciale fructe de mare
44	de	Italienische Küche
44	ro	Bucatarie italianaå
45	de	Mexikanische Küche
45	ro	Bucătărie mexicană
46	de	Japanische Küche
46	ro	Bucataria japoneza
47	de	Mediterrane Küche
47	ro	Bucătărie mediteraneană
48	de	Vegane Gerichte
48	ro	Mâncăruri vegane
49	de	Meeresfrüchte-Spezialitäten
49	ro	Speciale fructe de mare
50	de	Italienische Küche
50	ro	Bucatarie italianaå
51	ru	Закуски
51	ro	Aperitive
52	ru	Салаты
52	ro	Salate
53	ru	Мясо
53	ro	Carne
54	ru	Десерты
54	ro	Deserturi
55	ru	Напитки
55	ro	Băuturi
56	ru	Паста
56	ro	Paste
57	ru	Закуски
57	ro	Aperitive
58	ru	Салаты
58	ro	Salate
59	ru	Мясо
59	ro	Carne
60	ru	Десерты
60	ro	Deserturi
61	ru	Напитки
61	ro	Băuturi
62	ru	Паста
62	ro	Paste
75	de	fds
9	en	456
9	de	12365
\.


--
-- Data for Name: t_client; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_client (id, email, name, default_localization, currency, uuid, key) FROM stdin;
2	LaMamaliga@example.com	La Mamaliga	ro	MDL	e31b5565-e1d2-4f89-8154-76f8e14a33ae	La Mamaliga
3	CulinaryCrossroads@example.com	Culinary Crossroads	en	MDL	9a3b2d6f-4cd8-4339-bd30-03eb8d79dfff	crossroads
4	tba@mail.com	Iana Restaurant	ru	MDL	6109a8c8-8588-4196-87de-035b81d9a110	iana
1	Bratwursthaus@example.com	Bratwursthaus	ru	MDL	c764c4c4-db52-4184-8f68-5009c181b50e	Bratwursthaus
\.


--
-- Data for Name: t_client_secondary_language; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_client_secondary_language (client_id, localization) FROM stdin;
2	en
2	ro
3	ro
3	ru
1	de
1	en
4	ro
4	ru
\.


--
-- Data for Name: t_item; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_item (id, price, sequence, category_id, image_url, quantity1, unit1, quantity2, unit2, quantity3, unit3, quantity4, unit4, quantity5, unit5, default_name, default_description, uuid, image_blur_hash, deleted_at) FROM stdin;
666	140.00	2	74	\N	500.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Овощное плато	Плато из сезонных овощей	905889c9-68f5-4cd1-9689-73853acff5e4	\N	\N
387	100.00	1	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/coconut_shrimp.webp	6.000	PI	\N	\N	\N	\N	\N	\N	\N	\N	Crispy Coconut Shrimp with Sweet Chili Dipping Sauce	Delicious shrimp coated in crispy coconut flakes, served with a side of sweet chili dipping sauce.	83986eae-37e0-4dd3-928b-b99153c7d419	URMGYC^+g$xv~VMyIUafPWRlVYxFRQnPa1xt	\N
388	80.00	2	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/spinach_artichoke_dip.webp	230.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Spinach and Artichoke Dip with Warm Tortilla Chips	Creamy spinach and artichoke dip served with warm tortilla chips.	6416856c-0c1f-4d08-b71f-49b9d0a6dfb8	UTLW:|~ox]tm^*W?NeoI-;E3R*aJt7o#bHsl	\N
389	90.00	3	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/tempura_vegetables.webp	225.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Tempura Vegetables with Ponzu Dipping Sauce	Assorted vegetables lightly battered and fried to perfection, served with a tangy ponzu dipping sauce.	558fa10e-a8c3-4b27-8068-209c91fcd9a4	UaLNJC~pkstS?atQWrogyEX9V[jYogt7ayt6	\N
390	110.00	4	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/beef_sliders.webp	175.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Miniature Beef Sliders with Caramelized Onions and Gruyere Cheese	Juicy miniature beef burgers topped with caramelized onions and melted Gruyere cheese.	4baa5c07-e20d-41bf-bf93-bcc19e94a1f5	UJKwk3~p-o-;-oS4wHtQBD-;aKM{D%-oXnRj	\N
391	70.00	5	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/avocado_bruschetta.webp	4.000	PI	\N	\N	\N	\N	\N	\N	\N	\N	Avocado Bruschetta with Balsamic Glaze	Fresh avocado slices served on toasted bread, drizzled with balsamic glaze.	da619712-06e3-44f1-b76b-4bc3c5be5110	UKJkZI~pbxxu~pxtIUWApKR%MwRj_3-:Io?b	\N
392	90.00	6	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/buffalo_chicken_wings.webp	175.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Buffalo Chicken Wings with Blue Cheese Dip and Celery Sticks	Spicy buffalo chicken wings served with creamy blue cheese dip and fresh celery sticks.	bf6ec2e6-63d8-4c5f-b9cc-e42acb7c4c5e	UKIqu:?[YOyD-pS~R6sqyYRoQmRPx]Vse,t+	\N
669	80.00	5	74	\N	240.000	G	100.000	G	\N	\N	\N	\N	\N	\N	Хумус	Хумус подаётся с начос и микрозеленью	a9972b2a-32bd-422c-bc4d-0c7769cc8ed9	\N	\N
462	254543.00	9	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	twtwer		604b983a-abc2-4e68-8b3d-a469522509f1	\N	2024-11-07 12:03:04.419548
735	21.00	9	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dasdsadsa	dasdas	a95357e9-a0fd-489e-a51a-ce1ec9eb99cf	\N	\N
393	80.00	7	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/grilled_halloumi.webp	250.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Grilled Halloumi Cheese with Honey and Thyme	Grilled halloumi cheese drizzled with honey and sprinkled with thyme.	0011a00f-f34a-40f6-9e1e-bf23a90956ed	UNKwON~VY6Rk^kE2R*rqA0XTjDnOVr?HX7S4	\N
17	120.00	1	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Pina colada	Alcohol drinks	7f95e6f4-d41b-4855-aa7c-8214834ddb59	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
36	5.00	5	9	\N	5.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Meal 5	Non alcoholic drinks	3e8a57ad-afd9-4321-b7cf-4835a180426c	LEHLh[WB2yk8pyoJadR*.7kCMdnj	2024-09-15 14:45:29.697363
115	12.50	6	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	e02dc5e8-a8bb-49cf-b55a-04db5dd27036	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
113	12.50	4	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	7631bc25-92da-4030-8999-eb313d2fe3c7	\N	2024-09-22 14:04:02.326237
463	23.00	1	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	авыавы	авыавыавы	3fc9c042-da79-459d-b51a-eda637a71be8	\N	\N
117	12.50	8	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	73befc9c-e9af-420e-912a-f8e8c956eb3f	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
8	80.00	2	7	https://murano.blob.core.windows.net/murano-container/photo5350450965372843006.jpg	300.000	G	50.000	G	10.000	G	\N	\N	\N	\N	Mamaliga	Tu stii si asta	ff436328-5868-4429-85f4-c634c48f86fc	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
35	5000.00	1	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	fdsfds	Tasty sausage with very tasty salad	824f6a41-27b6-4a96-8c14-80632a949b5e	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
114	12.50	5	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	729e05f6-7f9e-42f1-8952-5c524011e9cc	\N	2024-09-22 14:48:13.465211
449	300.00	0	8	\N	200.000	G	150.000	G	\N	\N	\N	\N	\N	\N	New item for delete testing 3	Served with a tomato-based sauce and curry powder or with a curry ketchup	8332083d-de3a-4001-964c-cbd678264cdc	\N	\N
7	70.00	5	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Limonadă	Extrem de scump	220392e8-a80a-441c-b65a-62ca449828c9	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
5	120.00	3	5	\N	400.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Long island	Cumpărați-o prietenei dvs. și sexul este garantat	4b79833e-96eb-4ce3-9f78-c7008e0032f6	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
37	6.00	6	10	\N	6.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Meal 6	Rice with stir fried pork	2c3fb8ff-687d-4931-95a1-0cbaad0a82f2	LEHLh[WB2yk8pyoJadR*.7kCMdnj	2024-09-15 14:45:05.421313
457	10.00	5	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dsa		0f8dc85f-57fe-43ce-9db0-336a00314818	\N	\N
4	150.00	1	4		200.000	G	50.000	ML	\N	\N	\N	\N	\N	\N	Friptura de porc	Friptură de porc cu sos delicios de ceapă	92b412f3-d487-4adf-b73c-ec18992c1ca1	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
119	12.50	10	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	8a58749f-087b-4a92-ae21-5fe77fc8fb8d	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
121	12.50	12	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	7ed14b42-8218-46ed-a856-08aa12d8bc13	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
394	110.00	8	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/bacon_wrapped_dates.webp	230.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Bacon-Wrapped Dates Stuffed with Goat Cheese and Balsamic Reduction	Dates stuffed with creamy goat cheese, wrapped in bacon, and drizzled with balsamic reduction.	2f23fec4-606f-48d6-bab7-a674fa190378	UMJkAd~ptlW=~WxvW=M|kr-;t7t7%f%MIooe	\N
395	70.00	9	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/zucchini_fritters.webp	240.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Crispy Zucchini Fritters with Garlic Herb Aioli	Crispy fritters made from shredded zucchini, served with garlic herb aioli sauce.	3bb6e98b-23c7-422f-996c-79b5e0d8ed79	UMI}hW~qKR$%~p%MS3xa5WoMQ-o}a#%2V?NH	\N
396	90.00	10	57	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/vietnamese_spring_rolls.webp	8.000	PI	\N	\N	\N	\N	\N	\N	\N	\N	Vietnamese Fresh Spring Rolls with Peanut Dipping Sauce	Fresh spring rolls filled with vegetables and vermicelli noodles, served with peanut dipping sauce.	a63a989f-b4d8-4bab-93f4-a424be1784c6	UPI;z|~ptSxcx@WCoN$+58V@jXoLV[%3oetk	\N
38	7.00	7	11	\N	7.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Meal 7	Banana Shake	134f7c9e-0d3b-4ad6-814d-5bf3e48bc1ba	LEHLh[WB2yk8pyoJadR*.7kCMdnj	2024-09-15 14:08:44.136575
28	80.00	4	2	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Roti with mango	National dishes	f57f6e10-980b-4e52-9e3b-47d00ec1e85d	\N	2024-10-08 12:54:31.128459
29	350.00	2	1	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4Xk5F-713cqfJ4qyScYIf5nQWsGRnzFBbKA&usqp=CAU	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Pad Thai	Steaks	67af0fdb-bdfd-4357-8415-41afc5f52294	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
670	75.00	6	74	\N	190.000	G	100.000	G	\N	\N	\N	\N	\N	\N	Гуакамоле	Гуакамоле из свежего авокадо с добавлением острого перца и красного лука подаётся с начос	8596d0cb-04c3-41ab-a746-1252e837254d	\N	\N
450	123.00	4	8	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/sunset.png	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	abd		3c52ae3b-17af-4c36-8852-0f570e711e2f	UfJ@OAj]OFs.~payoLWV5?j@smWWW?j[WVoL	\N
458	10.01	2	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	req	re	55a69f07-2326-4af5-989b-26a50e194318	\N	\N
671	95.00	7	74	\N	140.000	G	80.000	G	30.000	G	30.000	G	\N	\N	Севиче из авокадо и лосося	Ракушки с лососем , авокадо и фирменной заправкой подаются на колотом льду	83df2724-9cfe-45f3-9514-a37d5fa572fa	\N	\N
736	100.00	10	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	gds	gfds	4f2a7471-4587-4c25-a1ff-1c7b51e79a96	\N	\N
738	54.00	12	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ytryur	yrtytryrt	6d2ebad6-91c0-4dce-9436-6fe51439cf37	\N	\N
30	750.00	3	1	https://www.kitchensanctuary.com/wp-content/uploads/2021/05/Szechuan-Chicken-Square-FS-18-300x300.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Stir fried chicken	Steaks2	bf626abc-f2b2-47d9-9e84-8db9ca9e4770	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
672	70.00	8	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Перец запечённый с сыром фета	\N	cc8cd1d3-e8e5-4657-8400-bb8eeaf5347d	\N	\N
2	14.99	1	2	https://www.the-girl-who-ate-everything.com/wp-content/uploads/2019/10/antipasto-salad-001-300x300.jpg	200.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Potato salad	Die gekochten Kartoffeln werden in Scheiben geschnitten und mit den weiteren Zutaten vermischt. Es können sowohl sogenannte Salzkartoffeln (ohne Schale gekocht) als auch die mit Schale gekochten Pellkartoffeln verwendet werden.	1a1704c8-d3a2-4ce4-a530-1a936fd2b851	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
673	45.00	9	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Маслины	\N	e7b57ed7-36b3-46af-ac85-ff2b9bdd37bd	\N	\N
110	12.50	1	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	a1655c62-73c6-487a-bb0c-879d444fdc08	\N	2024-09-15 14:57:56.552116
398	90.00	2	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/classic_greek_salad.webp	280.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Classic Greek Salad	Crisp lettuce, juicy tomatoes, cucumbers, red onions, Kalamata olives, and feta cheese tossed in Greek dressing.	cf71c4b3-d27a-4ffc-94fe-97b8f9dcf37a	UZKU1N%0x^xG~VV@n,jGx_Rjn*ae%MofR*t7	\N
399	110.00	3	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/grilled_caesar_salad.webp	320.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Grilled Caesar Salad	Crisp romaine lettuce topped with grilled chicken, parmesan cheese, and croutons, tossed in Caesar dressing.	e5efb1b8-894f-45ce-9725-31286ee92d89	UHH--^~VJEbc?axt%Mxu0iNH-mxt?H?HRjRj	\N
400	80.00	4	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/spinach_strawberry_salad.webp	300.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Spinach Strawberry Salad	Fresh spinach leaves topped with sliced strawberries, red onions, feta cheese, and candied pecans, served with balsamic vinaigrette.	a989b702-9540-447f-895f-503b81828ba6	UDF$2_~oyEsr_2x]f,-p9xM|IARQ9at7RPkV	\N
401	70.00	5	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/sesame_chicken_salad.webp	270.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Sesame Chicken Salad	Mixed greens topped with sesame-crusted chicken, mandarin oranges, sliced almonds, and crispy chow mein noodles, served with sesame ginger dressing.	7610d9ab-081e-4f66-88cc-26edfb83b951	UHG[WR?tEk%M~VSgM|r]0ONywd%2MytQnN%0	\N
674	30.00	10	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Маринованные огурчики	\N	2d927681-c7ff-4046-8794-3361cb4c82bf	\N	\N
111	12.50	2	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	2487ccb3-90b4-4f25-acf0-bfa381ef0b3a	\N	2024-09-15 14:58:09.285226
675	45.00	11	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Оливки	\N	ffc1f87a-7914-43fe-b3cf-911291bef429	\N	\N
112	12.50	3	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	420388f2-455d-4f6a-a6b3-f563e00d18ad	\N	2024-09-15 14:58:25.640671
676	15.00	12	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Лимон	\N	8499d673-d733-4860-afea-ad7cbce5613d	\N	\N
116	12.50	7	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	e2aca996-c51b-4631-877a-70f4d6cf0c2b	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
18	70.00	6	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Limonade	Non alcoholic drinks	682e9929-6e09-4199-8564-cb971bf4613a	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
3	1.49	0	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Cola	\N	7b7cd27a-a11a-43c4-b267-bd2182e110ba	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
120	12.50	11	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	3ff2b092-2a28-44fc-b641-03c0c06bc68c	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
122	12.50	13	26	https://murano-storage.fra1.cdn.digitaloceanspaces.com/Bratwursthaus/lasagna.webp	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	33cb6655-8bdb-4e42-b0e4-743afdf87519	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
27	70.00	2	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Banana Shake	Non alcoholic drinks	bd7c59de-afbe-4991-b132-13be04a8e5d8	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
26	120.00	3	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Bubble Tea	Alcohol drinks	c5625ad6-d708-476d-b46c-e18349e046fb	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
25	120.00	5	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Thai Tea	Alcohol drinks	005f48d6-26c7-48e6-ba77-0fdcaa3492c2	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
15	120.00	4	3	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS3i-zVWar2KX5uiJLcR3QOQqSk9oxiNCmEwA&usqp=CAU	0.000	\N	\N	\N	\N	\N	\N	\N	\N	\N	Long island	Alcohol drinks	1953f539-67f4-40ef-9927-2719e14f083b	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
464	21.00	2	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	12	12	66724467-c2b0-423b-b381-b5aa0ce065e8	\N	\N
21	150.00	8	1	https://norisushi.md/wp-content/uploads/2023/01/Tom-yum-clasic-1-300x300.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Tom Yum	Steaks	ca7ea5f7-6106-4b37-a4fb-e216a60252c0	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
20	81.00	0	2	https://www.dietetik.ro/data/Images/mamaliga_dovleac.JPG	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Mamaliga	National dishes	cce4197b-5bf0-4ea8-afa1-ff13a9fb815e	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
118	12.50	9	26	\N	250.000	G	20.000	ML	\N	\N	\N	\N	\N	\N	Lasagna EN	Traditional beef lasagna EN	3f4c87d4-2a9c-46f2-ac28-d4ad46c71e34	\N	2024-10-11 08:51:46.680133
31	1150.00	4	1	https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLg-eMQAJKRfBacr0mZNZNO8NES_c_FTJk3Q&usqp=CAU	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Rice with stir fried pork	Steaks	c80f781a-0290-4616-b422-ef6ec6ca73c1	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
402	80.00	6	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/caprese_salad.webp	310.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Caprese Salad	Fresh mozzarella cheese, ripe tomatoes, and basil leaves drizzled with balsamic glaze and olive oil.	a8e55bd0-15ab-4e0e-a987-2e8b6ef74554	UHIX,8.6PVOq~pW,X5t71OoyDg$*%#-:obg2	\N
403	90.00	7	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/kale_quinoa_salad.webp	290.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Kale Quinoa Salad	Fresh kale leaves mixed with cooked quinoa, cherry tomatoes, cucumber, avocado, and a lemon vinaigrette dressing.	a5486ebc-94cf-4c9d-a409-5d48add33497	UGGR^o_2%4%f~Ut5IVM|RCs;V@a_NG?HtR%L	\N
404	80.00	8	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/taco_salad.webp	330.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Taco Salad	Crisp lettuce topped with seasoned ground beef, black beans, corn, diced tomatoes, shredded cheese, and tortilla strips, served with salsa and sour cream.	247a1fa8-7fd1-4b6a-939d-5de30a15dffb	UKGk,a^*JDt8~oj[WBxu9#Row[V[Roxva_oc	\N
405	100.00	9	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/waldorf_salad.webp	300.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Waldorf Salad	A classic salad made with crisp apples, celery, grapes, walnuts, and mayonnaise served on a bed of lettuce.	5dd2d740-3e59-4c8a-9535-c4e77e5a8a57	UHHegj~oNzx]~nRVf9tS4[IXxBkBRoR.%1xu	\N
406	90.00	10	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/mediterranean_orzo_salad.webp	270.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Mediterranean Orzo Salad	Orzo pasta mixed with diced cucumbers, cherry tomatoes, Kalamata olives, feta cheese, red onion, and a lemon herb vinaigrette.	c835e409-b168-448c-9f9d-a1d2823e049a	UOJHdS^*pc%g~qRPM{V[KRX9RPxaxu%2WTt7	\N
407	80.00	11	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/beet_goat_cheese_salad.webp	310.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Beet and Goat Cheese Salad	Roasted beets served with creamy goat cheese, mixed greens, candied walnuts, and a balsamic glaze.	e3193e1c-ee80-44aa-a079-431159396228	UCFhkx~CT0xa=|s:M|xt0fIUR5xGE1%M%2$*	\N
408	280.00	1	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/ribeye_steak.webp	200.000	G	100.000	G	\N	\N	\N	\N	\N	\N	Grilled Ribeye Steak with Rosemary Garlic Butter	Juicy ribeye steak grilled to perfection and topped with fragrant rosemary garlic butter.	765ce237-3ff7-4baa-956f-68d2b03bd3ac	UEG8o*~V9cIp-.9ZIVs:9bM{I9M|Rk?F-:Ny	\N
409	250.00	2	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/bbq_ribs.webp	230.000	G	50.000	G	\N	\N	\N	\N	\N	\N	Slow-Roasted BBQ Ribs with Tangy Homemade Sauce	Tender pork ribs slow-roasted until fall-off-the-bone tender, glazed with tangy homemade BBQ sauce.	21d1b4b6-9811-409e-b82d-30209dbe62f4	UDGH_0_NY5RP?Hj?M|Rk7f%2H?R+%z?b=|-V	\N
410	320.00	3	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/duck_breast.webp	250.000	G	50.000	G	\N	\N	\N	\N	\N	\N	Pan-Seared Duck Breast with Cherry Port Reduction	Duck breast seared to perfection and served with a rich cherry port reduction sauce.	b17c7ce3-90b5-418d-bf07-09c94b7cdd8e	U3HL0f-W004.}TS$E1+[00X,4T~qx@^P_NKj	\N
411	360.00	4	59	\N	260.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Garlic and Herb Crusted Rack of Lamb	Tender rack of lamb coated with a flavorful garlic and herb crust, roasted to perfection.	beaca40a-a113-44c0-9b7c-7c9912c80cdc	\N	\N
412	400.00	5	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/beef_wellington.webp	250.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Beef Wellington with Mushroom Duxelles and Puff Pastry	Tender beef fillet topped with mushroom duxelles, wrapped in puff pastry, and baked until golden brown.	3aa1b937-c0e2-430c-9ff5-8b786cfab62e	UVJav9~WXnS5?H%LRkogNyWBZ~s:ozxus:Rj	\N
413	220.00	6	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/pork_belly.webp	370.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Braised Pork Belly with Apple Cider Glaze	Tender pork belly slow-braised in apple cider and glazed to perfection, served with a sweet and tangy apple cider glaze.	da5fc843-cb5d-4a6e-89c7-279ee17a35ae	UBEf1n~pPqF2DiD%j]ow00E1L}wHkV_2xaWC	\N
414	270.00	7	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/honey_glazed_ham.webp	280.000	G	80.000	G	50.000	G	\N	\N	\N	\N	Honey Glazed Ham with Pineapple Chutney	Succulent ham glazed with honey and served with a side of tangy pineapple chutney.	33aa75de-f0ed-4fcd-935d-0792d14faa90	USIhEN~pb^WBpJt6nhRPAItSxGodxVtRbwoz	\N
415	310.00	8	59	\N	300.000	G	80.000	G	\N	\N	\N	\N	\N	\N	Spicy Korean BBQ Short Ribs with Kimchi	Tender short ribs marinated in spicy Korean BBQ sauce, grilled to perfection, and served with tangy kimchi.	a11b6d2e-947e-4246-9bd1-ea55dd5f2eda	\N	\N
416	190.00	9	59	\N	260.000	G	50.000	G	\N	\N	\N	\N	\N	\N	Jamaican Jerk Chicken with Mango Salsa	Chicken marinated in spicy Jamaican jerk seasoning, grilled to perfection, and served with fresh mango salsa.	fc34091c-a243-4556-9259-98794a3b1aca	\N	\N
417	350.00	10	59	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/moroccan_lamb_tagine.webp	270.000	G	50.000	G	50.000	G	\N	\N	\N	\N	Moroccan Lamb Tagine with Apricots and Almonds	Tender lamb stewed with Moroccan spices, apricots, and almonds, served in a traditional tagine pot.	9393ef4f-cd4c-4c93-90b1-0555df2bfa34	UDGHbpRj0#of~AS$D*N_5qRlvyxaJ:9^%0M{	\N
418	80.00	1	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/chocolate_lava_cake.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Chocolate Lava Cake with Vanilla Ice Cream	\N	de58f51c-c62b-46b2-91b7-f2dbc17c0781	UCC~-g~AxaIV00NHoffP0M9aD%%M%L?G?aV[	\N
419	100.00	2	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/new_york_cheesecake.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New York Cheesecake with Berry Compote	\N	0a829914-5374-4110-a267-86953cce5c77	UUGuwJ~p%gxuWYRjt7tR9uIoMxR*MxxaNGju	\N
420	95.00	3	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/tiramisu.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Tiramisu with Espresso Soaked Ladyfingers	\N	ac320e3c-f2da-44a6-80d9-210ecc100b68	UIG*vT~V%hx]RiIoV@%102NIROjZM|t7WXIp	\N
421	90.00	4	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/creme_brulee.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Crème Brûlée with Caramelized Sugar	\N	cb99d484-369a-4f66-8eb5-351ee14b3177	UWJHms_N%gof~pozRjt6T0WWIAWB%M-;M{R*	\N
422	80.00	5	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/key_lime_pie.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Key Lime Pie with Whipped Cream	\N	b1cb59d3-af1f-44c7-954b-6727d718c390	USJarz~oR,IpSdM|V@s,9cIpRjxaDj?G%Mt8	\N
423	95.00	6	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/apple_pie.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Apple Pie with Cinnamon Streusel Topping	\N	c4c2bd2b-5ecb-44f4-94ea-56c980faa701	UJIDs;}@t-j]~BD%NHV@GHD*jFMxtRxtofs:	\N
424	100.00	7	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/molten_chocolate_brownie.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Molten Chocolate Brownie with Salted Caramel Sauce	\N	721395c4-a907-431c-a13c-466cb1f467fc	UBD+*pWX%gIUD%^*4.IU00aKIAW=~pE1~p-:	\N
739	2321.00	13	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	dasdas	dsadas	e9c9aa5c-0e70-4e81-aa03-200fd25f6760	\N	\N
461	3242.00	3	8	\N	100.000	L	\N	\N	\N	\N	\N	\N	\N	\N	tre		aceba2b5-0468-4644-bf75-fb22d20b72e8	\N	\N
425	80.00	8	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/lemon_meringue_tart.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Lemon Meringue Tart with Fresh Berries	\N	eb5e6ae8-ef90-482d-95ad-fa7dc66ef95e	UbJ*9h~p9wW;$$t7IqRjo}x]jFaKtQ%M%LRk	\N
426	69.00	9	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/raspberry_sorbet.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Raspberry Sorbet with Mint Garnish	\N	d80b0f90-5ded-4f7f-9e50-3db285fb474e	UOH.Ti4TOYI.~qMxIpNZE2MxMxo}?wIUsSa~	\N
427	75.00	10	60	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/bread_pudding.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Bread Pudding with Bourbon Caramel Sauce	\N	eea949c5-02d6-4f14-8a27-87dd71920288	UGF5W}~ByDOYR%Ris8oK0#tRn4$%-Txt%gIp	\N
428	65.00	1	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/lemonade.webp	250.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Freshly Squeezed Lemonade	\N	25856e1a-abd7-4fad-9777-d11bd4aa7ba5	UVL;jA~pIW-:.8%No#WCIwxtxVWCognNjDa}	\N
429	70.00	2	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/iced_tea.webp	500.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Iced Tea	\N	19320073-130a-4948-8179-95293816f1a6	UEDI]%yW14~9t5WYIWnh5nf+#SR+%eoe$*%M	\N
430	80.00	3	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/virgin_mojito.webp	350.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Virgin Mojito	\N	b40deb72-b9ea-4a9f-8ae0-35bb32c55651	UgG,C7_MRSx[x]x]ogWARQWEt6s-NFWAoJj?	\N
432	85.00	5	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/coconut_water_pineapple.webp	250.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Coconut Water with Pineapple	\N	823a6e57-e001-4245-aef3-903b59b28ef0	UXJRgI~qIW-pODbwfloc57xu-:R*xut6s:kD	\N
434	100.00	7	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/margarita_on_the_rocks.webp	150.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Margarita on the Rocks	A classic cocktail made with tequila, triple sec, lime juice, and served over ice.	dc5fa73b-8773-40d3-98e5-713b5995d052	UdHf-J~qM|xtxZofWXoJRkj[oJWBtRs.s,WC	\N
435	130.00	8	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/old_fashioned.webp	170.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Old Fashioned	A timeless cocktail made with bourbon, sugar, bitters, and a twist of orange zest.	03738c76-a3b4-49e1-9a01-51ac3122b132	UKKcqU~ot+^O+a$%RQM{9un#VsS$?tWXx]xt	\N
436	120.00	9	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/moscow_mule.webp	150.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Moscow Mule	A classic cocktail made with vodka, ginger beer, lime juice, and served over ice in a copper mug.	c064b4b0-0532-4ca5-b253-2ac98db540ba	UgKBN:~px]xukVtQV@s:bbj[RPRj%2s:tQR*	\N
437	100.00	10	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/gin_and_tonic.webp	160.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Gin and Tonic	A classic cocktail made with gin, tonic water, and served over ice with a twist of lime.	21c967c1-a2f5-4fd6-a586-171a408f9eae	UKGA5x~p00bw.8%MRkRkIAt7%Lax4:WXxDM{	\N
438	140.00	11	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/whiskey_sour.webp	120.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Whiskey Sour	A classic cocktail made with whiskey, lemon juice, sugar, and optionally an egg white, served over ice.	e3ce5aba-f800-4365-a49a-2b3b768bbe46	UQMQLx~qFyi^_3xvRiM{EkWBQ-of$$M{Ne%M	\N
439	120.00	1	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Spaghetti Carbonara	\N	f5543816-96a2-4d73-af4b-bbb16546e339	\N	\N
440	140.00	2	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Wild Mushroom Risotto	\N	23e62266-0f69-4db3-88f2-2f557aac17a6	\N	\N
441	169.00	3	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Shrimp Linguine Alfredo	\N	5c8303f2-9a2c-4bcd-a08f-bddb5ecb30ae	\N	\N
442	120.00	4	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Penne Arrabbiata	\N	1f7d507e-6216-4c35-afcb-94389a913f06	\N	\N
443	240.00	5	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Lobster Ravioli in a Creamy Tomato Sauce	\N	b971ac2f-1367-49bd-8b79-67ce5e0397e1	\N	\N
444	159.00	6	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Butternut Squash Risotto with Sage	\N	77ab3dc3-46ea-4ded-8bcb-ea9afd88c3e9	\N	\N
445	170.00	7	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Fettuccine Alfredo with Grilled Chicken	\N	1cda003f-415d-46b5-91f9-f81b8a2ad154	\N	\N
446	165.00	8	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Pesto Cavatappi with Sun-Dried Tomatoes	\N	841d4749-87e3-4e65-ad71-be888e66a26c	\N	\N
447	180.00	9	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Seafood Paella Risotto	\N	130ab662-c4e8-4680-882a-d3840cf504d6	\N	\N
448	140.00	10	62	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Rigatoni Bolognese	\N	ff2a3967-d76e-452d-9e99-e8ece24b85f1	\N	\N
14	150.00	7	1		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Steak with Sauce	Steaks	26b75249-b36a-4860-b729-c15a2c2de24b	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
32	10.00	5	1	https://murano-storage.fra1.cdn.digitaloceanspaces.com/a9e82c37-5dc2-4920-8c8a-a62a0892fac6/Tom-Kha-Gai-square-FS-9.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Sausage with salad	Tasty sausage with very tasty salad	0b114f21-3d3f-4d94-90af-04981d021449	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
433	110.00	6	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/classic_mojito.webp	220.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Classic Mojito	A refreshing cocktail made with white rum, fresh mint, lime, soda water, and simple syrup.	fc064227-a169-4980-b7f6-61e8a75d4d65	UIE:u2?]4V-:SuS$NHn#9HM|xtWCS%tRoMM|	\N
431	80.00	4	61	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/raspberry_lemonade_spritzer.webp	250.000	ML	\N	\N	\N	\N	\N	\N	\N	\N	Raspberry Lemonade Spritzer	\N	c4a48537-0a0c-4359-aa68-df8298bdb638	UUJaQN.mKN^j-ppIS$nOTJ$*v~WBkSad$Ms:	\N
740	324432.00	14	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	fds	fdsfds	addca30f-6f16-4e37-910a-c58ba1e326a4	\N	\N
33	16.99	1	1	https://homemadehome.com/wp-content/uploads/2021/03/Bavette-Steak-with-Whiskey-Garlic-Cream-Sauce-300x300.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Steak with fries	Steak with fries	1135189d-7d93-45ed-938e-65fa08d221cc	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
668	135.00	4	74	\N	200.000	G	50.000	G	50.000	G	50.000	G	50.000	G	Сет Брускетт	Четыре вида брускетт составленные из прошутто с веточками рукколы ; моцарелла с черри ; лосось с авокадо ; анчоусы с вяленными томатами и соусом песто	1e34cbd6-2ebf-4951-b975-8fecbd809751	\N	\N
34	14.99	6	1	https://norisushi.md/wp-content/uploads/2023/01/Tom-yum-clasic-1-300x300.jpg	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Cream soup	Cream soup with mushrooms	356f6261-da7e-4aa5-9873-ff97e7cdd703	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
397	100.00	1	58	https://murano-storage.fra1.cdn.digitaloceanspaces.com/CulinaryCrossroads/grilled_chicken_cobb_salad.webp	300.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Grilled Chicken Cobb Salad	Fresh greens topped with grilled chicken, crispy bacon, hard-boiled eggs, avocado, tomatoes, and blue cheese crumbles.	854b139b-dd38-4483-b24b-c7469755215f	UKHn~R~pO[tm~Vt5x]W=ObVv$*xt.8a$RQt7	\N
453	123.00	0	9	\N	123.000	KG	\N	\N	\N	\N	\N	\N	\N	\N	new	1235	2fda08b7-8930-4ef4-a336-5b569472b6c9	\N	\N
737	100.00	11	1	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	fewrew	rewrew	eb688cc1-be5f-4771-83cd-56f927475a2d	\N	\N
1	19.99	0	1	https://images.squarespace-cdn.com/content/v1/5cf177f386563e0001bfce76/1616278925532-Z0DYXA9KMKTB1NHVJXMS/pork_green_pepper_sausage.jpg?format=300w	150.000	G	50.000	G	\N	\N	\N	\N	\N	\N	Sausage with fries	Served with a tomato-based sauce and curry powder or with a curry ketchup	064acf6e-9bff-4ac6-a4c7-2bc7ac1b4fc2	LEHLh[WB2yk8pyoJadR*.7kCMdnj	\N
454	43243.43	7	8	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	432r23	fewfwerew	1d03b6c9-608c-40eb-a56e-9c66e07fcf64	\N	2024-10-14 18:36:32.417129
687	140.00	2	65	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Спагетти с морепродуктами	\N	e69ad44c-2de2-4e04-9d85-dbe29d17cf51	\N	\N
688	100.00	3	65	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Спагетти карбонара	\N	119807d0-8d03-49d3-b0d7-c5cc0424a128	\N	\N
686	135.00	1	65	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Чёрная паста 4 сыра	\N	b5c048bb-621b-4e61-adad-6eae980269b6	\N	\N
695	120.00	1	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Italiano	\N	76f56372-a22c-4b58-a778-0fbf6b47a4d3	U6L2^q^fV@{20P0Mm,}t00M|.7%MGuRiH@#l	\N
685	120.00	0	65	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Фетучини с курицей и грибами	kjlkjljkljlkj	fe7cce8b-be78-4a7a-8682-5e0c9e9b89d4	U6L2^q^fV@{20P0Mm,}t00M|.7%MGuRiH@#l	\N
682	55.00	6	64	\N	180.000	G	20.000	G	\N	\N	\N	\N	\N	\N	Жареная корюшка	Корюшка приправленная чесноком обжаривается до золотистой корочки и подаётся с долькой лимона	2361a7da-1799-4f69-a1d5-9ee570082aeb	\N	\N
683	55.00	7	64	\N	170.000	G	30.000	G	\N	\N	\N	\N	\N	\N	Сыр Пане с ягодным конфитюром	Бруски сыра в панировке обжаренные во фритюре до золотистой корочки подаются с ягодным джемом	a6245f19-a903-40b1-8676-5a7ffe1d3d13	\N	\N
684	130.00	8	64	\N	130.000	G	50.000	G	\N	\N	\N	\N	\N	\N	Креветки Панко с соусом	Очищенные креветки в панировке обжариваются до золотистой корочки и подаются с соусом Sweet Chilly	5228cdc3-8f7a-41a4-a946-7bacc0fcd695	\N	\N
689	65.00	1	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Капрезе	\N	2b37f5aa-0923-4c76-a73c-0f74e939c3be	\N	\N
690	80.00	2	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Греческий	\N	00daa99c-a1ea-4bba-bfb4-ddee19f7e5e2	\N	\N
691	90.00	3	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Салат с тунцом	\N	e0286ca3-40a1-421f-a385-f6bc9e78bcfb	\N	\N
692	85.00	4	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Тёплый мясной салат	\N	89066ca2-0fec-4d7b-9672-d834b187a030	\N	\N
693	80.00	5	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Цезарь с курицей	\N	99bd9d12-2f6a-4f82-8e35-588cd7960983	\N	\N
694	120.00	6	66	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Салат с креветками и авокадо на гриле	\N	a7ffa767-12c6-4ab2-9f8d-a6b28365df52	\N	\N
696	115.00	2	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Greek	\N	88493928-acbe-4118-90bf-26c74a2e3e49	\N	\N
697	120.00	3	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Quattro Formaggi	\N	8b8b2953-6ba3-4655-a6ab-db8584f3eff2	\N	\N
698	120.00	4	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Pepperoni	\N	978955de-d850-44ec-8bde-5d592d761911	\N	\N
699	100.00	5	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца с беконом и яйцом	\N	0dcaf641-7a20-4b6a-8f0b-ad8885b709bb	\N	\N
700	125.00	6	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Carbonara	\N	d8af24ec-0749-4589-b7a9-d4643ea2228b	\N	\N
701	125.00	7	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца с грушей и горгонзолой	\N	fe3381e0-04a5-4eaf-8c34-52d264195e07	\N	\N
702	125.00	8	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца BBQ	\N	15f4ee41-9996-4d1b-a02b-816e0305011a	\N	\N
703	130.00	9	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Мясная	\N	a6f960b0-301b-4ba8-ac4d-b5c208272807	\N	\N
704	125.00	10	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Tropicana	\N	3ef2377f-4e9f-4768-b6ae-fca61a028c15	\N	\N
705	125.00	11	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца Цезарь	\N	8337ab91-b1a0-4f3c-b3a7-4c3ba068fe93	\N	\N
706	20.00	12	67	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пицца с сырным бортом	\N	39694adb-bd4a-46c7-9fcd-5c46d6220088	\N	\N
707	15.00	1	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Sweet Chili	\N	6a572a27-8595-461f-86a4-a5ed644e1690	\N	\N
708	10.00	2	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Американская горчица	\N	c43ee951-e8e3-4be0-9592-1c0d42299fe6	\N	\N
709	10.00	3	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Майонез	\N	bee4cbc0-4c01-49bc-85f1-4662bc49ca15	\N	\N
710	10.00	4	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Кетчуп	\N	3b308623-088a-46bb-9098-8d3abe4465da	\N	\N
711	10.00	5	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Барбекю	\N	67099612-56b2-4c19-9d8a-9642e4f13d36	\N	\N
712	15.00	6	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Песто	\N	395a7ff5-125f-4e0f-adff-6ed9a2662147	\N	\N
713	20.00	7	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Соус Дор Блю	\N	a6f8d727-8db8-46cb-b567-ece07c2bcce4	\N	\N
714	15.00	8	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Тар-тар	\N	0c3d413c-11cd-4a41-ad53-e33e32ad7e52	\N	\N
715	15.00	9	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Сырный соус	\N	e1d2ae82-9c0d-4e3a-837b-f3e4dee2f3e0	\N	\N
716	10.00	10	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Сметана	\N	b5005b71-f83b-4e9f-8017-93cc9fa2a13a	\N	\N
717	15.00	11	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Соус Цезарь	\N	cbe41c1b-d6c1-4c6f-84cd-39f533e780e7	\N	\N
718	10.00	12	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Мёд	\N	b243038e-0f86-40e1-8df3-1e9e24ceab2f	\N	\N
719	15.00	13	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Соус Дзадзики	\N	4477d3f8-39e0-43d6-b476-0a4d0cbe9323	\N	\N
720	15.00	14	68	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Пикантный соус	\N	4fd3489e-2759-4195-ac1a-d044611193b9	\N	\N
721	30.00	1	69	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Картошка фри	\N	0b38dbe5-2c86-4dab-bb9a-fb7164b70e37	\N	\N
722	30.00	2	69	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Картофель запечённый	\N	a36f23de-7522-4790-bd22-487e61ec9a56	\N	\N
723	45.00	3	69	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Овощи гриль	\N	5b6aceb0-4f93-403b-bc83-f06b9e4f7498	\N	\N
724	55.00	1	70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Суп с фрикадельками	\N	b98df711-e148-4aca-85c8-43f5cd1e0fcc	\N	\N
725	55.00	2	70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Крем суп из тыквы с креветкой и гренками	\N	e0078784-fc04-4efa-8a2d-ddae0eafc81d	\N	\N
726	65.00	3	70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Сырный суп-крем с беконом	\N	04bed14c-9f02-417b-9220-d51eb9d2ad9f	\N	\N
727	40.00	1	71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Ушки свиные	\N	b438e9c6-7cc3-46bb-9097-19e7509eaf24	\N	\N
728	40.00	2	71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Кальмар сушёный	\N	3d35a8a6-7be5-4b6e-b49a-7a4ed85d2f90	\N	\N
729	35.00	3	71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Сыр косичка	\N	3b36211b-bfb5-4eff-b5b5-2062afd1e119	\N	\N
730	40.00	4	71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Кальмар Чили	\N	8fd1803f-7752-4f6a-99b8-db2401ca483e	\N	\N
731	40.00	5	71	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Гренки с чесноком	\N	bab35177-1fb9-4c67-ad9d-633898e581cc	\N	\N
732	55.00	1	72	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Чизкейк	\N	db2e7c08-7570-48a9-aeee-b2dc487c8ed5	\N	\N
733	55.00	2	72	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Тирамису	\N	49fc10dc-dbc0-41ae-a578-31b903811f1c	\N	\N
734	50.00	3	72	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Крем Брюле	\N	22180f06-c57f-44f6-b116-f538ac46d826	\N	\N
649	65.00	1	63	\N	260.000	G	110.000	ML	50.000	G	100.000	G	\N	\N	Гранола с фруктами	Гранола подаётся с сезонными фруктами и йогуртом	5d3138c1-9455-4ac8-84ba-0e3e391b0352	\N	\N
650	60.00	2	63	\N	180.000	G	140.000	G	30.000	G	10.000	G	\N	\N	Омлет Пуляр	Омлет Пуляр подаётся с обжаренным беконом и свежей рукколой	4a54fc00-e643-4221-b4b9-e05b485ab12c	\N	\N
651	80.00	3	63	\N	420.000	G	100.000	G	100.000	G	120.000	G	50.000	G	Английский завтрак	Глазунья, картошка фри, обжаренные на гриле сосиски и дольки свежего помидора с Американской горчицей	71040cf1-88ae-4022-89f7-965c228de0b2	\N	\N
652	50.00	4	63	\N	250.000	G	150.000	G	50.000	G	50.000	G	\N	\N	Сырники	Сырники под фруктовым джемом со сливочной кнелькой	ee4e5621-52aa-4dab-8931-81ea86b2c98a	\N	\N
653	80.00	5	63	\N	300.000	G	200.000	G	50.000	G	40.000	G	10.000	G	Оладьи из шпината	Оладьи из шпината подаются со сливочным кремом и гуакамоле из авокадо накрытый шариком из рукколы	f9211e92-c9c6-433a-a208-b92abcbb6ef2	\N	\N
654	55.00	6	63	\N	300.000	G	100.000	G	50.000	G	50.000	G	100.000	G	Шакшука	Шакшука из тушенных томатов, лука и сладкого перца с добавлением двух куриных яиц, специй и свежей зелени	dc4d2121-efed-4f69-9e16-0348c4f02a6e	\N	\N
655	65.00	7	63	\N	220.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Сладкие Гонконгские Вафли	Сладкие Гонконгские Вафли подаются с мороженым, солёной карамелью и маршмеллоу	ea8721ec-d725-4a96-bddb-e73d47b1026a	\N	\N
656	65.00	8	63	\N	250.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Соленые Гонконгские Вафли	Гонконгские Вафли подаются с куриной копчёной грудкой и свежими овощами	a30ded45-6723-4547-94b3-56844b2ca2f5	\N	\N
657	125.00	1	73	\N	370.000	G	200.000	G	140.000	G	30.000	G	\N	\N	Свинина с овощами гриль	Свиная вырезка и овощи обжариваются на гриле и подаются с соусом BBQ	f1d1b37f-6749-44ec-a569-9f2023021f32	\N	\N
658	110.00	2	73	\N	350.000	G	200.000	G	120.000	G	30.000	G	\N	\N	Грудка с овощами гриль	Куриная грудка и овощи обжариваются на гриле и подаются с соусом Цезарь	531f4fc7-f752-45e7-b54b-dab475d410f7	\N	\N
659	110.00	3	73	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Цыплёнок с кускус	\N	42c7e126-cfb9-427a-8bf6-d2542b52dd08	\N	\N
660	120.00	4	73	\N	340.000	G	200.000	G	90.000	G	50.000	G	\N	\N	Мидии в сливочном Просекко	Мясо мидии томится в сливочном соусе с Просекко и подаётся с тремя кусочками Чиабатты	9b0ea6d3-935b-4778-8e1d-158b422cbe7e	\N	\N
661	120.00	5	73	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Филе скумбрии с рататуем в прованских травах	\N	94a06f98-eca3-4355-8768-f4dc7ec55ab5	\N	\N
662	180.00	6	73	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Рёбра BBQ	\N	a9c1eafb-0b7b-4b1e-88a8-7b2459957953	\N	\N
663	165.00	7	73	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Кострица на гриле с домашним салатом	\N	80f62ba4-c066-4076-a880-e67114c8b4ed	\N	\N
677	80.00	1	64	\N	140.000	G	100.000	G	50.000	G	\N	\N	\N	\N	Куриное филе Панко	Куриные наггетсы в сухарях Панко обжариваются до золотистой корочки и подаются с картофелем фри	14b653f9-1c56-46a8-87a5-138b3ebcb270	\N	\N
678	105.00	2	64	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Крылышки в соусе Sweet Chili	\N	3f9a5f18-d01f-42c2-b74f-4b7b2e895434	\N	\N
679	95.00	3	64	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Куриные колбаски с фри	\N	aa0d34db-44fb-46b7-85c9-363bbfd27aa2	\N	\N
680	75.00	4	64	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Твистер с курицей	\N	7c0daf75-46d8-43dd-a3c2-bc21fe85e186	\N	\N
681	90.00	5	64	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Твистер с креветкой	\N	13aeffe3-ce8d-41dc-86a5-90b41753d296	\N	\N
667	140.00	3	74	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Мясное плато	\N	41a0d509-bd9f-4ee0-a5ca-dfc7cbca4663	\N	\N
665	180.00	1	74	\N	500.000	G	\N	\N	\N	\N	\N	\N	\N	\N	Фруктовое плато	Плато из сезонных фруктов	97029703-b178-42c8-ad19-ac9c2163bcc3	\N	\N
664	180.00	0	74	\N	300.000	G	50.000	ML	\N	\N	\N	\N	\N	\N	Смешанное плато	Пастрама, грудка копчёная, прошутто , пармезан , сыр Brie ,сыр DorBlue и мёд	57f92042-3213-4182-b3d3-54adfdc2445d	\N	\N
6	120.00	4	5	https://murano-storage.fra1.cdn.digitaloceanspaces.com/LaMamaliga/DALL·E 2024-03-05 21.29.03 - A sophisticated presentation of Whiskey Sour, aligning with the earlier successful images but set against a simple monotone light background. The cock.webp	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Pina colada	Simțiți-vă ca în Hawaii	6ca8d146-18ec-46b2-8814-7fee1760bf0d	UQMQLx~qFyi^_3xvRiM{EkWBQ-of$$M{Ne%M	\N
\.


--
-- Data for Name: t_item_localization; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_item_localization (item_id, localization, name, description) FROM stdin;
1	de	Wurst mit Pommes	Wird mit einer tomatenhaltigen Sauce und Currypulver oder mit einem Curry-Ketchup serviert
1	en	Sausage with fries	Served with a tomato-based sauce and curry powder or with a curry ketchup
2	de	Kartoffelsalat	The boiled potatoes are cut into slices and mixed with the other ingredients. Both so-called boiled potatoes (cooked without peel) and jacket potatoes boiled with peel can be used.
2	en	Potato salad	Die gekochten Kartoffeln werden in Scheiben geschnitten und mit den weiteren Zutaten vermischt. Es können sowohl sogenannte Salzkartoffeln (ohne Schale gekocht) als auch die mit Schale gekochten Pellkartoffeln verwendet werden.
3	de	Cola	\N
3	en	Cola	\N
4	en	Steak with Sauce	Pork steak with delicious onion sauce
4	ro	Friptura de porc	Friptură de porc cu sos delicios de ceapă
5	en	Long island	Buy it to your girlfriend and sex is guaranteed
5	ro	Long island	Cumpărați-o prietenei dvs. și sexul este garantat
6	en	Pina colada	Feel yourself like in Hawaii
6	ro	Pina colada	Simțiți-vă ca în Hawaii
7	en	Limonade	Extremely overpriced
7	ro	Limonadă	Extrem de scump
8	en	Mamaliga	Yellow moldovan thing
8	ro	Mamaliga	Tu stii si asta
387	ru	Хрустящие Кокосовые Креветки с Сладким Чили Соусом	Вкусные креветки, обваленные в хрустящие кокосовые хлопья, подаются с соусом из сладкого чили.
388	ru	Шпинат и Артишок Дип с Теплыми Чипсами из Тортильи	Кремовый шпинат и артишоковый дип подается с теплыми чипсами из тортильи.
389	ru	Овощи Темпура с Кислым Соусом Понзу	Разнообразные овощи, слегка обваленные и обжаренные до идеального состояния, подаются с кислым соусом понзу.
14	en	Steak with Sauce	Steaks
14	de	Friptura de porc	Fripturi
15	en	Long island	Alcohol drinks
15	de	Long island	Băuturi alcoolice
388	ro	Nachos cu Sos de Spanac	Crema de spanac și sos de anghinare servită cu chipsuri de tortilla calde.
17	en	Pina colada	Alcohol drinks
17	de	Pina colada	Băuturi alcoolice
18	en	Limonade	Non alcoholic drinks
18	de	Limonadă	Băuturi nealcoolice
110	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
110	ro	Lasagna	Lasagna tradițională cu carne de vită
21	en	Tom Yum	Steaks
21	de	Tom Yum	Fripturi
111	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
111	ro	Lasagna	Lasagna tradițională cu carne de vită
112	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
112	ro	Lasagna	Lasagna tradițională cu carne de vită
113	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
113	ro	Lasagna	Lasagna tradițională cu carne de vită
25	en	Thai Tea	Alcohol drinks
25	de	Thai Tea	Băuturi alcoolice
26	en	Bubble Tea	Alcohol drinks
26	de	Bubble Tea	Băuturi alcoolice
27	en	Banana Shake	Non alcoholic drinks
27	de	Banana Shake	Băuturi nealcoolice
28	en	Roti with mango	National dishes
28	de	Roti with mango	Mâncăruri naționale
29	en	Pad Thai	Steaks
29	de	Pad Thai	Fripturi
31	en	Rice with stir fried pork	Steaks
31	de	Rice with stir fried pork	Fripturi
32	en	Sausage with salad	Tasty sausage with very tasty salad
32	de	Bratwurst mit Salat	Schmeckt gut
114	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
34	en	Cream soup	Cream soup with mushrooms
114	ro	Lasagna	Lasagna tradițională cu carne de vită
34	de	Supcrem	blaaa
115	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
115	ro	Lasagna	Lasagna tradițională cu carne de vită
116	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
116	ro	Lasagna	Lasagna tradițională cu carne de vită
117	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
117	ro	Lasagna	Lasagna tradițională cu carne de vită
118	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
118	ro	Lasagna	Lasagna tradițională cu carne de vită
119	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
119	ro	Lasagna	Lasagna tradițională cu carne de vită
120	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
120	ro	Lasagna	Lasagna tradițională cu carne de vită
121	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
121	ro	Lasagna	Lasagna tradițională cu carne de vită
122	de	Lasagne	Traditionelle Lasagne mit Rindfleisch
122	ro	Lasagna	Lasagna tradițională cu carne de vită
422	ro	Prăjitură cu Cremă de Lime	\N
20	en	Mamaliga	National dishes
20	de	Mamaliga	Mâncăruri naționale
30	en	Stir fried chicken	Steaks432
30	de	Stir fried chicken	Fripturi
649	ro	abc	cde
390	ru	Мини-Бургеры из Говядины с Карамелизованным Луком и Топленым Сыром Грюйер	Сочные мини-бургеры из говядины с карамелизованным луком и топленым сыром Грюйер.
391	ru	Авокадо Брускетта с Бальзамической Глазурью	Свежие ломтики авокадо подаются на поджаренном хлебе, политые бальзамической глазурью.
392	ru	Куриные Крылышки Буффало с Соусом Блю Чиз и Прутом Сельдерея	Острые куриные крылышки Буффало подаются с кремовым соусом блю чиз и свежими палочками сельдерея.
393	ru	Халлуми на гриле с Медом и Тимьяном	Жареная на гриле сырная халлуми, политая медом и посыпанная тимьяном.
393	ro	Brânză Halloumi la Grătar cu Miere și Cimbru	Brânză halloumi la grătar stropită cu miere și presărată cu cimbru.
394	ru	Финики	Финики, начиненные кремовым козьим сыром, завернутые в бекон и политые бальзамическим соусом.
395	ru	Хрустящие Кабачковые Котлеты с Соусом Аиоли с Чесноком и Травами	Хрустящие котлеты из цуккини, подается с соусом аиоли с чесноком и травами.
396	ru	Вьетнамские свежие весенние рулеты с арахисовым соусом	Свежие весенние рулеты, наполненные овощами и вермишели, подаются с арахисовым соусом.
397	ru	Салат Кобб с Курицей на Гриле	Свежие зеленые листья, приправленные куриным мясом с гриле, хрустящим беконом, вареными яйцами, авокадо, помидорами и крошкой сыра голубого.
398	ru	Классический Греческий Салат	Хрустящий листовой салат, сочные помидоры, огурцы, красные луковицы, каламатские оливки и сыр фета, заправленные греческим соусом.
399	ru	Салат Цезарь с Курицей на Гриле	Хрустящий ромэн, приправленный куриным мясом с гриле, пармезаном и гренками, заправленный соусом Цезарь.
400	ru	Салат со Шпинатом и Клубникой	Свежие листья шпината, украшенные нарезанными клубниками, красным луком, сыром фета и карамелизованными орехами пекан, подаются с бальзамическим уксусом.
401	ru	Салат с Курицей и Кунжутом	Смешанные зеленые листья, украшенные куриным мясом в кунжуте, мандаринами, нарезанными миндальными орехами и хрустящими лапшой чау-мин, подаются с соусом из имбиря и кунжута.
402	ru	Салат Капрезе	Свежий сыр моцарелла, спелые помидоры и листья базилика, политые бальзамической глазурью и оливковым маслом.
403	ru	Салат из Кале и Киноа	Свежие листья кале, смешанные с вареной киноа, черри-томатами, огурцом, авокадо и заправленные лимонным винегретом.
404	ru	Салат Тако	Хрустящий листовой салат, приправленный мелко молотым говяжьим фаршем, черными бобами, кукурузой, нарезанными помидорами, натертой сырой и полосками тортильи, подается с сальсой и сметаной.
422	ru	Пирог Кей Лайм с Взбитыми Сливками	\N
390	ro	Mini Burgeri de Vită cu Ceapă Caramelizată și Brânză Gruyere Topită	Burgeri de vită în miniatură acoperiți cu ceapă caramelizată și brânză topită Gruyere.
394	ro	Rulouri cu Bacon și Brânză de Capră	Bacon, brânză de capră, sos balzamic
391	ro	Bruschete cu Avocado	Felii de avocado servite pe pâine prăjită, stropite cu sos balsamic.
392	ro	Aripi de Pui Buffalo cu Sos de Brânză Dorblu	Aripi de pui picante Buffalo servite cu sos cremos de brînză dorblu și țelină.
397	ro	Salată Cobb cu Piept de Pui la Grătar	Verdețuri cu piept de pui la grătar, bacon crocant, ouă fierte, avocado, roșii și brânză dorblu.
395	ro	Chiftele Crocante de Dovlecei	Chiftele crocante făcute din dovlecei rasi, servite cu sos aioli de usturoi.
396	ro	Rulouri Vietnameze cu Sos de Arahide	Rulouri umplute cu legume și tăiței din orez, servite cu sos de arahide.
398	ro	Salată Grecească Clasică	Frunze de salată, roșii, castraveți, ceapă roșie, măsline și brânză feta.
399	ro	Salată Caesar cu Piept de Pui la Grătar	Frunze de salată, piept de pui la grătar, brânză parmezan și crutoane.
402	ro	Salată Caprese	Brânză mozzarella, roșii coapte, frunze de busuioc stropite cu sos balsamic și ulei de măsline.
400	ro	Salată de Spanac cu Căpșuni	Spanac, căpșuni, ceapă roșie, brânză feta și nuci pecan caramelizate.
401	ro	Salată de Pui cu Susan	Legume, piept de pui, portocale, migdale tăieței crocanți și susan.
403	ro	Salată de Kale și Quinoa	Frunze de kale amestecate cu quinoa fiartă, roșii cherry, castravete, avocado.
421	ro	Crème Brûlée cu Zahăr Caramelizat	\N
405	ru	Салат Вальдорф	Классический салат из хрустящих яблок, сельдерея, винограда, грецких орехов и майонеза, подается на листьях салата.
406	ru	Средиземноморский Салат из Орзо	Паста орзо смешанная с нарезанными огурцами, черри-томатами, оливками Каламата, сыром фета, красным луком и лимонно-травяным винегретом.
407	ru	Салат из Свеклы и Козьего Сыра	Печеные свеклы подаются с кремовым козьим сыром, смешанными зелеными листьями, карамелизованными грецкими орехами и бальзамической глазурью.
408	ru	Рибай Стейк на Гриле с Розмариновым Чесночным Маслом	Сочный стейк рибай гриль, приправленный до совершенства и запеченный с ароматным розмариновым чесночным маслом.
409	ru	Медленно Запеченные Свиные Рёбра с Кислым Домашним Соусом BBQ	Нежные свиные рёбра, медленно запеченные до того, что мясо легко отходит от кости, покрытые кислым домашним соусом BBQ.
410	ru	Грудка Утки обжаренная на Сковороде с Вишневым Портовым Соусом	Грудка утки обжаренная до идеального состояния и подается с богатым вишневым портовым соусом.
411	ru	Баранина в Корке из Чеснока и Трав	Нежные ребрышки баранины, облитые вкусной коркой из чеснока и трав, запеченные до идеального состояния.
412	ru	Бифштекс Веллингтон с Грибной Дюкселью и Слоенным Тестом	Нежный филей говядины, покрытый грибной дюкселью, завернутый в слоеное тесто и запеченный до золотистой корочки.
413	ru	Тушеный Свиной Брюхан с Глазурью из Яблочного Сидра	Нежное свиное брюхо медленно тушится в яблочном сидре и покрывается глазурью из яблочного сидра до совершенства.
414	ru	Ветчина с Медовой Глазурью и Ананасовым Чатни	Сочная ветчина, покрытая медовой глазурью и подается с ананасовым чатни сочного вкуса.
415	ru	Острые Корейские Жареные Короткие Рёбра с Кимчи	Нежные корейские короткие рёбра, маринованные в острой корейской барбекю-пряной подливе, обжаренные до совершенства и подаваемые с кислым кимчи.
416	ru	Ямайский Острый Курицы с Манго Сальсой	Курица, маринованная в острой ямайской пряной приправе джерк, обжаренная до совершенства и подаваемая с свежей манго сальсой.
417	ru	Марокканская Баранина Таджин с Абрикосами и Миндалем	Нежное мясо ягнёнка тушеное с марокканскими специями, абрикосами и миндалем, подается в традиционной посуде таджин.
418	ru	Шоколадный Лава Кейк с Ванильным Мороженным	\N
419	ru	Чизкейк Нью-Йорк с Ягодным Компотом	\N
420	ru	Тирамису с Пропитанными Эспрессо Бисквитами	\N
421	ru	Крем Брюле с Карамелизированным Сахаром	\N
405	ro	Salată Waldorf	O salată clasică făcută cu mere crocante, țelină, struguri, nuci și maioneză.
406	ro	Salată Mediteraneană	Castraveți cubulețe, roșii cherry, măsline, brânză feta, ceapă roșie, lămâie și ierburi.
407	ro	Salată de Sfeclă și Brânză de Capră	Sfeclă coaptă servită cu brânză de capră cremoasă, verdețuri mixte, nuci caramelizate și sos balsamic.
418	ro	Tort Vulcan din Ciocolată cu Înghețată de Vanilie	\N
419	ro	Cheesecake New York cu Fructe de Pădure	\N
420	ro	Tiramisu	\N
408	ro	Steak Rib Eye la Grătar	Steak rib eye la gratar cu unt, rozmarin și usturoi.
410	ro	Piept de Rață cu Vișine și Porto	Piept de rață prăjit la și servit cu un sos de vișine și porto.
409	ro	Coaste de Porc la Cuptor cu Sos de BBQ\n	Coaste de porc, coapte lent, glazurate cu sos de BBQ.
411	ro	Coaste de Miel Crustate cu Usturoi	Coaste de miel cu usturoi și ierburi.
413	ro	Pancetta cu Glazură de Suc de Măr.	Pancetta fragedă fiartă lent în suc de măr, servită cu o glazură dulce-acrișoară din suc de măr.
412	ro	Steak Wellington cu Ciuperci în Aluat.	File de vită fraged cu duxelles cu ciuperci, învelit în aluat sfârâmicios și copt.
414	ro	Jambon Glazurat cu Miere și Chutney de Ananas	Jambon glazurat cu miere ,servit cu chutney de ananas acrișor.
415	ro	Coaste Coreene Picante la Grătar cu Kimchi	Coaste fragede marinate în sos coreean BBQ picant cu kimchi.
416	ro	Pui Jerk Jamaican cu Salsa de Mango	Pui marinat în condimente picante de jerk jamaican, servit cu salsa de mango.
417	ro	Tajină de Miel Marocană cu Caise și Migdale	Miel fraged cu condimente marocane, caise și migdale, servit într-un vas tradițional.
423	ru	Яблочный Пирог с Корицей и Крошкой	\N
423	ro	Plăcintă cu Mere și Topping de Cimbru	\N
424	ru	Расплавленный Шоколадный Брауни с Солёным Карамельным Соусом	\N
425	ru	Лимонный Тарт с Белковым Кремом и Свежими Ягодами	\N
426	ru	Малиновый Сорбет с Украшением из Мяты	\N
427	ru	Хлебный Пудинг с Карамельным Соусом на Бурбоне	\N
428	ru	Свежевыжатый Лимонад	\N
429	ru	Ледяной Чай	\N
430	ro	Mojito Fără Alcool	\N
431	ru	Малиновый Лимонад Спритцер	\N
432	ru	Кокосовая Вода с Ананасом	\N
432	ro	Apă de Cocos cu Ananas	\N
433	ru	Классический Мохито	Освежающий коктейль с белым ромом, свежей мятой, лаймом, содовой и простым сиропом.
433	ro	Mojito Clasic	Un cocktail răcoritor făcut cu rom alb, mentă proaspătă, lime, apă minerală și sirop simplu.
434	ru	Маргарита на Льду	Классический коктейль с текилой, трипл секом, соком лайма, подаваемый с льдом.
435	ru	Олдфэшн	Вечный коктейль с бурбоном, сахаром, биттером и цедрой апельсина.
435	ro	Old Fashioned	Un cocktail atemporal făcut cu bourbon, zahăr, amăreli și o felie de coajă de portocală.
436	ru	Московский Мул	Классический коктейль с водкой, имбирным пивом, соком лайма, подаваемый с льдом в медной кружке.
436	ro	Moscow Mule	Un cocktail clasic făcut cu vodcă, bere de ghimbir, suc de lime și servit peste gheață într-o ceașcă de cupru.
437	ru	Джин Тоник	Классический коктейль с джином, тоником, подаваемый с льдом и ломтиком лайма.
438	ru	Виски Сауэр	Классический коктейль с виски, лимонным соком, сахаром и по желанию белком яйца, подаваемый с льдом.
438	ro	Whiskey Sour	Un cocktail clasic făcut cu whisky, suc de lămâie, zahăr și opțional albuș de ou, servit peste gheață.
439	ru	Спагетти Карбонара	\N
439	ro	Spaghetti Carbonara	\N
440	ru	Ризотто с Дикими Грибами	\N
440	ro	Risotto cu Ciuperci Sălbatice	\N
441	ru	Лингвине Альфредо с Креветками	\N
442	ru	Пенне Аррабиата	\N
442	ro	Penne Arrabbiata	\N
443	ru	Равиоли с Лобстером в Кремовом Томатном Соусе	\N
443	ro	Ravioli cu Homar într-un Sos Cremos de Roșii	\N
444	ru	Ризотто из Тыквы с Шалфеем	\N
444	ro	Risotto de Dovleac cu Salvie	\N
445	ru	Феттуччине Альфредо с Курицей на Гриле	\N
445	ro	Fettuccine Alfredo cu Pui Grill	\N
446	ru	Каватаппи с Песто и Сушеными Помидорами	\N
447	ru	Ризотто Паэлья с Морепродуктами	\N
447	ro	Risotto de Paella cu Fructe de Mare	\N
448	ru	Ригатони Болоньезе	\N
448	ro	Rigatoni Bolognese	\N
387	ro	Creveti Crocanți cu Sos Dulce Acrișor 	Creveți crocanți cu fulgi de cocos, serviți cu un sos dulce acrișor.
389	ro	Legume Tempura cu Sos Tangy Ponzu	Legume prăjite acoperite cu aluat, servite cu un sos tangy ponzu.
404	ro	Salată Taco	Lipie, tocătură de vită, fasole neagră, porumb, roșii, brânză rasă, servite cu salsa și smântână.
424	ro	Briose de Ciocolată cu Caramel Sărat	\N
425	ro	Tartă de Lămâie și Fructe de Pădure	\N
427	ro	Budincă de Pâine cu Sos de Caramel cu Bourbon	\N
426	ro	Sorbet de Zmeură cu Menta	\N
441	ro	Linguine Alfredo cu Creveti	\N
428	ro	Limonadă	\N
446	ro	Cavatappi cu Pesto și Roșii Uscate	\N
429	ro	Ceai Rece	\N
431	ro	Limonadă de Zmeură	\N
434	ro	Margarita cu Gheață	Un cocktail clasic făcut cu tequila, triple sec, suc de lime și servit peste gheață.
437	ro	Gin Tonic	Un cocktail clasic făcut cu gin, apă tonică și servit peste gheață cu o felie de lime.
430	ru	Мохито безалкогольный	\N
33	en	Steak with fries	Steak with fries
33	de	Steak mit Pomes	Steak mit Pomes
\.


--
-- Data for Name: t_order; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_order (id, status, table_session_id, uuid, created_at, status_changed_at, status_changed_by, comment) FROM stdin;
1	ACCEPTED	38	58401c97-f7bd-41b6-a904-aa675e714a43	2023-11-19 18:27:57.041537	2023-11-19 19:45:29.320836	1	\N
2	ACCEPTED	38	181bda68-925c-4a62-9808-e176c0fb524a	2023-11-19 18:37:18.425088	2023-11-19 19:45:29.334268	1	\N
3	ACCEPTED	38	e5fa691a-8d36-4c9c-b8eb-f8b8d4557c23	2023-11-19 19:29:23.661532	2023-11-19 19:45:29.341696	1	\N
4	ACCEPTED	38	f94e60d3-3821-4a31-b595-0b10f5f03483	2023-11-19 19:32:24.347862	2023-11-19 19:45:29.35195	1	с майонезом\n
5	ACCEPTED	38	352ac679-1754-4cd7-8c37-3bd4742db93e	2023-11-19 19:32:50.251492	2023-11-19 19:45:29.364459	1	\N
6	ACCEPTED	30	d46d1e1e-3505-4743-b28f-ead98c7bcdfe	2023-11-19 21:01:52.420096	2023-11-19 21:07:41.228628	1	Schneller
7	ACCEPTED	30	94ada12f-8d2d-47ea-aa83-660243c267a4	2023-11-19 21:02:33.213111	2023-11-19 21:07:41.249194	1	\N
8	ACCEPTED	30	d324edfd-83d8-44e9-9e6c-ec98995d6f7b	2023-11-19 21:04:50.503056	2023-11-19 21:07:41.258011	1	\N
9	ACCEPTED	30	d10f4afe-1ae2-4158-931e-300f09f375a3	2023-11-19 21:08:47.660889	2023-11-19 21:09:28.777305	2	\N
10	ACCEPTED	49	23915e01-3396-4f05-93a7-1793f7b235a5	2023-11-19 21:18:41.028408	2023-11-19 21:20:17.26787	1	Hui
11	DECLINED	58	bfbe82e1-86fd-45dc-a6dd-8904820a5a21	2023-11-19 21:22:23.943016	2023-11-19 21:24:22.855244	2	\N
12	ACCEPTED	50	5e640a3c-df29-4fd7-b7a2-12194f64e23d	2023-11-21 17:26:56.365776	2023-11-21 17:27:28.896058	2	\N
19	ACCEPTED	60	0c8f3dc3-266b-4c86-9170-608accc6445d	2023-11-30 17:32:22.371298	2023-11-30 17:32:53.867375	5	\N
20	DECLINED	60	01d7ab2a-cef9-49c5-b292-ded8cca09845	2023-11-30 17:33:29.978767	2023-11-30 17:33:39.445817	5	\N
21	DECLINED	60	31bca627-d8cf-4653-ad6b-43f1d47fd2d1	2023-11-30 17:33:51.108009	2023-11-30 17:34:03.736823	2	\N
25	ACCEPTED	60	1f6bd3b7-a09c-4ebb-b04d-250eff0c5f67	2023-11-30 17:35:31.91248	2023-11-30 17:35:56.375243	5	\N
26	ACCEPTED	60	99d0f36d-b32e-4c02-9e48-88f6b9440642	2023-11-30 17:35:46.045082	2023-11-30 17:35:56.396667	5	\N
15	ACCEPTED	57	47dedb54-6683-4b0e-ac31-afb87be5f3f5	2023-11-30 17:24:16.003707	2023-11-30 17:41:43.718541	2	No onion
16	ACCEPTED	57	34b8b7a3-1b5c-4a8d-9367-2454998e05ff	2023-11-30 17:29:05.767553	2023-11-30 17:41:43.727533	2	\N
17	ACCEPTED	6	6535e4d1-c12d-4311-a35a-cce814a6e6a6	2023-11-30 17:30:56.850003	2023-11-30 17:42:12.540073	2	No onion
18	ACCEPTED	6	d48a97e2-1ab3-42a9-a5e8-52cb82469eaa	2023-11-30 17:31:31.763555	2023-11-30 17:42:12.548103	2	\N
22	ACCEPTED	6	d01c5b41-b84a-4c06-a297-34aca46475ff	2023-11-30 17:34:50.786806	2023-11-30 17:42:12.554627	2	\N
23	ACCEPTED	6	2d266087-d606-485f-a946-904a0db86a9c	2023-11-30 17:35:01.179087	2023-11-30 17:42:12.563851	2	\N
24	ACCEPTED	6	670b303d-b67e-4f41-a51e-766117720f75	2023-11-30 17:35:14.107457	2023-11-30 17:42:12.57117	2	\N
27	ACCEPTED	6	1739a277-5fa2-466a-8894-f713d464e01c	2023-11-30 17:39:58.023362	2023-11-30 17:42:12.581706	2	\N
29	ACCEPTED	74	7b02582f-4999-42c0-bf35-ce16004b0599	2023-11-30 17:44:03.049031	2023-11-30 17:44:28.087971	2	\N
28	ACCEPTED	73	3925bd30-020e-4923-a331-afe36dcbb17f	2023-11-30 17:42:51.126106	2023-11-30 17:45:24.318897	2	\N
30	ACCEPTED	74	853fbdcd-7ae5-4d4e-a4d6-4f5f0c0c15cd	2023-11-30 18:21:55.74566	2023-11-30 18:22:09.98064	2	\N
31	ACCEPTED	75	e06cb1d9-3fb9-4a90-ab56-514c7b195c67	2023-11-30 18:50:31.390268	2023-11-30 18:50:43.190483	5	\N
13	ACCEPTED	39	f405ce0f-19c3-4b4f-a719-fcc6b03d747f	2023-11-29 15:41:02.888827	2023-12-01 05:36:12.657687	1	\N
14	ACCEPTED	39	63f16047-77f1-485e-ad71-76ec8f02279c	2023-11-29 15:43:46.999134	2023-12-01 05:36:12.663528	1	\N
32	ACCEPTED	39	986eaeda-cbb3-478f-ba5b-1794225fa7fa	2023-12-01 05:32:26.248953	2023-12-01 05:36:12.673993	1	\N
33	ACCEPTED	39	3071ebdb-62a7-48a8-8f25-1a4a36570f32	2023-12-01 05:35:03.650346	2023-12-01 05:36:12.679435	1	\N
34	ACCEPTED	39	3402e311-1b0c-499a-b598-de6bf2cb9c0e	2023-12-01 05:35:31.095643	2023-12-01 05:36:12.691466	1	\N
35	ACCEPTED	39	f9b02cfe-9245-448c-a718-cdeafe8ed72b	2023-12-01 05:35:40.267093	2023-12-01 05:36:12.697749	1	\N
36	ACCEPTED	39	144b3e96-0c58-4037-bf9b-91c22b63a69f	2023-12-01 05:36:03.337829	2023-12-01 05:36:12.703851	1	\N
37	ACCEPTED	39	a1f83a22-07e6-497a-b3b7-ecea48c3832a	2023-12-01 05:36:18.090505	2023-12-01 05:36:22.185584	1	\N
38	ACCEPTED	39	988fa4c0-e414-4c68-9de0-c92871d1f22b	2023-12-01 05:45:09.383576	2023-12-01 05:45:22.742338	1	Чсячсчсячсячсыфвфывыв
39	ACCEPTED	39	4ee2352a-d8c0-4148-9522-9b0d4d33e394	2023-12-01 08:41:48.320105	2023-12-01 08:42:22.690658	1	\N
40	ACCEPTED	39	e9b2b1bd-c007-4b06-b29d-152ab0c50b19	2023-12-01 08:47:41.17233	2023-12-01 08:47:49.122991	1	Sjhdjd
41	ACCEPTED	39	7444d202-8221-48f9-bdb5-e730a9925a44	2023-12-01 08:47:58.776549	2023-12-01 08:48:14.438847	1	\N
42	ACCEPTED	39	8a39baa3-2af3-4c33-b9c0-6d61c7e8e190	2023-12-01 08:48:08.60546	2023-12-01 08:48:14.445485	1	Test
43	DECLINED	39	8cf06a69-a387-4f23-b552-a86f8557b1be	2023-12-01 08:49:01.355572	2023-12-01 08:49:10.449736	1	\N
45	ACCEPTED	59	00650a00-785a-4228-b276-0e5ac3a688b1	2023-12-05 20:07:10.766295	2023-12-05 21:06:15.256012	3	\N
46	ACCEPTED	59	044e3422-2bfb-48f4-afc7-f682fc1614c5	2023-12-05 21:03:13.49801	2023-12-05 21:06:15.261556	3	\N
47	ACCEPTED	80	7c82c282-bd25-4c43-9d9c-5c9ed3541518	2023-12-06 17:48:40.249178	2023-12-06 17:50:53.832582	4	\N
48	ACCEPTED	80	601f218d-2794-4725-b244-1145d1f58a21	2023-12-06 17:52:09.076746	2023-12-06 17:56:13.475618	4	Рлд
49	ACCEPTED	80	588db2d6-991f-4bb8-933b-95e33a152064	2023-12-06 17:53:07.737453	2023-12-06 17:56:13.486923	4	\N
50	ACCEPTED	80	59f72601-338d-4780-bf66-fb96bc11818c	2023-12-06 17:53:38.124976	2023-12-06 17:56:13.491465	4	По
51	ACCEPTED	80	a89a32a4-9cd9-452d-b0e8-c47fb29689b9	2023-12-06 17:55:40.085502	2023-12-06 17:56:13.495916	4	\N
52	ACCEPTED	80	a3ea2465-e447-4182-b597-2f49d462a0ae	2023-12-06 18:04:35.961711	2023-12-06 18:06:02.553683	3	<div>Dima</div>
53	ACCEPTED	80	6d08c178-6b1d-41da-bd75-3d68058cac88	2023-12-06 18:05:33.36411	2023-12-06 18:06:02.558216	3	Popitka 2
54	ACCEPTED	80	bed09f69-c054-4031-8e1d-99dce715abf1	2023-12-06 18:06:21.320064	2023-12-06 18:06:43.660874	3	\N
55	ACCEPTED	80	06374a4a-38b7-48ae-b131-5b0fdd3f84f6	2023-12-06 18:06:28.239257	2023-12-06 18:06:43.66718	3	\N
56	ACCEPTED	80	4cf68c9e-7278-4e0f-bc6c-6089bea6c1a0	2023-12-06 18:08:33.366664	2023-12-06 18:08:53.426871	3	\N
57	ACCEPTED	80	5fd06fdf-3e5f-4587-9367-1e9b5bb2ce0c	2023-12-06 18:08:48.461873	2023-12-06 18:08:53.43073	3	\N
58	ACCEPTED	37	39910863-1b39-49b2-9e4f-1a22ad20405c	2023-12-06 18:10:58.523847	2023-12-06 18:11:08.240281	3	\N
60	ACCEPTED	79	7a56905b-5116-4f79-89bc-65853c773efa	2023-12-11 09:23:30.502582	2023-12-11 09:23:50.347021	1	\N
61	ACCEPTED	81	d07892e9-03e0-4f6f-a199-aba874e1d5b0	2023-12-11 09:24:38.422225	2023-12-11 09:25:10.025996	1	\N
62	ACCEPTED	76	ddd01528-ed79-4734-b54e-cd30b648dc5d	2023-12-12 17:02:24.519804	2023-12-12 18:58:47.496878	2	\N
63	ACCEPTED	76	dfa7de51-ee43-4d2c-b693-9f4f74047453	2023-12-12 17:03:12.109333	2023-12-12 18:58:47.501155	2	\N
64	ACCEPTED	76	bbfd3ecc-d7b3-4491-a13d-939e5e9a24c6	2023-12-12 17:03:37.460383	2023-12-12 18:58:47.509758	2	\N
65	ACCEPTED	76	c9088b1d-5f89-4d9b-8420-390f82517c34	2023-12-12 17:04:23.912181	2023-12-12 18:58:47.515544	2	\N
66	ACCEPTED	76	d1646911-6acd-465b-a4eb-364eafc4da52	2023-12-12 17:05:00.340021	2023-12-12 18:58:47.519026	2	\N
67	ACCEPTED	76	44c40ad5-40c8-4914-96a5-3d4831ed2728	2023-12-12 17:06:47.964278	2023-12-12 18:58:47.522522	2	\N
68	ACCEPTED	76	24e408e9-c73b-496d-9355-4b1526e240a1	2023-12-12 17:50:19.075616	2023-12-12 18:58:47.526046	2	\N
69	ACCEPTED	76	58fe5aff-01a8-4126-852c-4ebfe25dd639	2023-12-12 19:00:30.656903	2023-12-12 19:06:30.818754	2	\N
70	ACCEPTED	76	2be84a98-4c7e-4703-8688-5c14670a87fe	2023-12-12 19:07:01.223035	2023-12-12 19:07:20.341127	2	\N
71	ACCEPTED	76	6238c164-7a5a-4210-976f-d63dfb59e355	2023-12-12 19:07:34.015536	2023-12-12 19:07:42.074578	2	\N
72	ACCEPTED	76	2702a91e-1f89-4ffe-a0f5-2128d1aecd29	2023-12-12 19:10:19.357535	2023-12-12 19:10:23.103896	2	\N
59	ACCEPTED	37	49da4372-3bd0-479f-b603-29d48a180a1b	2023-12-07 13:19:08.384474	2023-12-12 19:12:08.482526	2	\N
73	ACCEPTED	84	cdb7366e-32bf-4fde-adb9-59e1b2cab278	2023-12-12 19:13:49.160831	2023-12-12 19:15:53.084583	2	\N
74	ACCEPTED	84	350ec627-5b45-497d-9d43-8f2ef597d998	2023-12-12 19:14:01.435408	2023-12-12 19:15:53.089566	2	\N
44	ACCEPTED	74	0ac891cc-81dc-4b81-9703-44630681d5a2	2023-12-05 18:13:02.196791	2023-12-12 20:09:40.163475	2	Ррлббтрго ложь д ом но лопат парооо толь ядыдв вдв а коущуткькл каллуутктк. Ушкову утра лутутву
75	ACCEPTED	74	7b5a987e-19af-47e2-8eea-be03cff715cf	2023-12-12 20:13:07.078873	2023-12-12 20:29:06.409219	5	\N
76	ACCEPTED	74	d6edefcb-fc40-4a3b-9aab-817671907cbf	2023-12-12 20:14:26.170577	2023-12-12 20:29:06.416759	5	\N
77	ACCEPTED	74	57a81fbf-09d7-4088-af5d-2ffbfbf8b438	2023-12-12 20:14:39.955903	2023-12-12 20:29:06.421663	5	\N
82	PENDING	22	89a60d86-cb85-49c1-8574-2c19639b6357	2023-12-18 15:08:12.098159	\N	\N	\N
78	ACCEPTED	74	a9dc5efe-0c02-4d19-8099-9e84a7b95ca0	2023-12-12 20:29:18.559142	2023-12-19 22:43:55.772256	3	\N
81	ACCEPTED	83	888dd9b2-938b-4edb-8716-a339e891391e	2023-12-13 10:17:24.733816	2023-12-19 22:43:57.470366	3	\N
83	PENDING	22	7db88702-b51a-4766-9563-ad21c54c8e70	2023-12-18 15:11:22.610961	\N	\N	\N
84	PENDING	22	2e7039d6-7cc0-462e-a675-b03fb355aa72	2023-12-19 22:42:57.102563	\N	\N	\N
79	ACCEPTED	82	a5b529a5-e7da-4714-8f01-3fa38a9a4714	2023-12-13 10:13:17.066587	2023-12-19 22:43:51.859514	3	\N
80	ACCEPTED	82	0081a0fb-3c93-4d7a-91df-79e53535247c	2023-12-13 10:15:41.255031	2023-12-19 22:43:51.893025	3	\N
85	ACCEPTED	92	543d5740-9eb0-45cb-8280-a250c5fcf9d5	2023-12-19 22:44:49.308191	2023-12-19 22:44:56.095761	3	\N
86	PENDING	22	b8ec9b1f-c541-46e8-9463-fe1b5ebe5c15	2023-12-20 07:44:48.077557	\N	\N	\N
87	PENDING	22	1c0c9a4c-72f9-4b77-a660-d320ef4b7fc1	2023-12-20 07:47:17.881913	\N	\N	\N
88	ACCEPTED	92	f59c5fcc-9d9c-471e-be7a-b3facf8d8cbe	2023-12-20 07:50:13.839537	2023-12-20 07:50:26.459279	3	\N
89	ACCEPTED	92	44049672-ac7d-4c00-aeaa-dc94fb29023a	2023-12-20 07:50:23.505828	2023-12-20 07:50:26.471048	3	\N
90	ACCEPTED	92	7e796879-3b0e-4af5-9767-66d326122680	2023-12-20 08:23:10.654337	2023-12-20 08:23:14.926067	3	\N
91	ACCEPTED	93	496f55d2-0b6e-4745-b94d-254a83e77cad	2023-12-20 08:26:09.021415	2023-12-20 08:26:18.142073	3	\N
92	ACCEPTED	93	cef94762-47da-403e-ad59-240bf1b570c5	2023-12-21 04:41:51.086562	2023-12-21 04:41:56.790341	3	\N
93	ACCEPTED	93	a0587f95-372f-4251-9c53-71c4b6a29dd9	2023-12-22 02:10:45.018564	2023-12-22 02:11:20.807421	1	\N
95	ACCEPTED	82	9d34e885-8f8b-40ad-b333-9e976cd131df	2023-12-23 08:21:01.86659	2023-12-23 08:21:24.156867	2	\N
96	ACCEPTED	82	a1cf2cd0-5403-40e1-ba25-d88652a6aeba	2023-12-23 08:21:32.064636	2023-12-23 08:40:51.459046	5	\N
97	ACCEPTED	82	68f77d26-0e56-46d7-85a3-4b7b1329a345	2023-12-23 08:31:50.756217	2023-12-23 08:40:51.492085	5	\N
98	ACCEPTED	82	26b32b9b-d494-4013-8b6d-10f7e6ec57a2	2023-12-23 08:32:05.582834	2023-12-23 08:40:51.503747	5	\N
99	ACCEPTED	82	cb86dab6-c713-4889-948a-19b09072b597	2023-12-23 08:32:16.124699	2023-12-23 08:40:51.513691	5	\N
100	ACCEPTED	82	1020f46a-6c84-455b-8d4a-5716e32baf7b	2023-12-23 08:32:33.085625	2023-12-23 08:40:51.528294	5	\N
94	ACCEPTED	93	690a0420-d5d6-448d-a3a4-7d21e4244847	2023-12-23 08:16:31.361479	2023-12-25 10:27:43.459242	2	\N
102	ACCEPTED	93	1c536b17-f929-4f99-b3f3-0d3a2e371ea5	2023-12-25 10:12:06.265399	2023-12-25 10:27:43.470009	2	Hello world!
103	DECLINED	93	67c368c8-cd37-45d7-b97b-0600d801d563	2023-12-25 10:30:44.550278	2023-12-25 10:31:08.395887	2	No shit
104	DECLINED	93	e009a8cd-925f-4762-ae38-4a2ffcb66cdd	2023-12-25 10:31:32.013682	2023-12-25 10:32:14.975882	2	\N
105	ACCEPTED	103	b6920f9d-b3cf-4ccd-9039-2d0215ccaee5	2023-12-25 10:33:11.114387	2023-12-25 10:36:15.703238	2	\N
106	ACCEPTED	103	992ce680-0f32-4cbb-ab0f-a8b5f21b5213	2023-12-25 10:33:51.30429	2023-12-25 10:36:15.707534	2	\N
107	ACCEPTED	31	ffb24c08-1502-4594-9a9f-e95af4254d1a	2023-12-26 14:01:36.549558	2023-12-26 14:02:19.625694	3	Привет
108	ACCEPTED	31	452957c1-1cae-42b9-8037-34e16409d9c0	2023-12-26 14:03:52.116158	2023-12-26 14:04:04.077797	3	\N
109	ACCEPTED	100	47cc5859-e7e2-4ad8-a49c-a9e05e2b5e78	2023-12-26 14:06:14.226988	2023-12-26 14:06:47.692832	7	\N
110	PENDING	31	1f3f9162-440e-4cb8-8ec4-adddee6bfa1b	2023-12-26 14:06:49.019821	\N	\N	\N
101	ACCEPTED	82	4f585e34-9185-4cfa-a807-54b9c1a820bb	2023-12-23 08:41:34.042591	2023-12-28 19:12:49.944822	7	\N
111	ACCEPTED	82	7187d53d-6af1-4181-bb22-40aa34a91dcd	2023-12-28 19:11:48.065533	2023-12-28 19:12:49.974376	7	\N
112	PENDING	31	cb1ee5e9-fbe1-4275-a126-bc84f6c5612e	2024-01-09 14:52:47.147006	\N	\N	\N
119	ACCEPTED	105	666b5e9a-11d8-45f2-9951-184dc3729c48	2024-03-03 23:42:03.389658	2024-03-14 14:09:48.530582	1	commodo dolore pariatur
120	ACCEPTED	105	ee8c368d-ee41-4d12-9662-217e288e5ac3	2024-03-03 23:43:23.319646	2024-03-14 14:09:48.542564	1	commodo dolore pariatur
155	PENDING	5	78ef60e7-d6f8-4013-a84e-d67c591a1f19	2024-03-22 10:09:49.582929	\N	\N	\N
127	ACCEPTED	108	47cad0a0-ecad-43ff-85fa-5fccbad54050	2024-03-12 20:18:32.256041	2024-03-12 20:41:40.300745	12	\N
128	ACCEPTED	108	b2ef8761-9da7-4f6a-bfb0-d729ebb7e320	2024-03-12 20:24:50.633468	2024-03-12 20:41:40.325797	12	\N
129	ACCEPTED	108	ce76f89a-e0b0-47a3-b778-3aaab14ca41e	2024-03-12 20:25:49.570014	2024-03-12 20:41:40.335528	12	\N
130	ACCEPTED	108	544097e2-6c8f-4808-9728-52a966c569ec	2024-03-12 20:29:23.226322	2024-03-12 20:41:40.347504	12	\N
132	ACCEPTED	109	eb6faa2f-74e2-457b-913b-9a96f1efa9ac	2024-03-14 13:20:38.435753	2024-03-18 19:42:02.973847	12	\N
133	ACCEPTED	109	0ae652aa-70ef-4cc3-95ed-df27823ce72d	2024-03-14 13:22:08.43473	2024-03-18 19:42:02.987503	12	\N
146	ACCEPTED	109	0868c788-5533-4a7f-9618-1bbac318271f	2024-03-19 14:08:01.281178	2024-03-20 21:03:34.032385	12	\N
147	ACCEPTED	109	2398b158-c656-49c6-9d0c-384384073944	2024-03-19 14:09:50.137635	2024-03-20 21:03:34.129202	12	Привет, хочу кушать 
148	ACCEPTED	109	cc957b50-bd60-4abe-90b9-74a0b064460d	2024-03-19 14:10:44.499047	2024-03-20 21:03:34.144524	12	\N
156	PENDING	5	4a37fb31-87c8-4a28-a213-a82a23cc41b9	2024-03-25 16:36:13.176869	\N	\N	123
157	PENDING	5	8c4cdc8f-7ed7-46e7-a2bc-8136cb071fc7	2024-03-25 21:10:25.5327	\N	\N	<string>
158	PENDING	5	edd00a45-d8e8-42d2-9e74-da120e784364	2024-03-25 21:10:47.725664	\N	\N	<string>
159	PENDING	5	8f0437bf-fd31-40cd-b2ae-6200ed107186	2024-03-25 19:38:30.969315	\N	\N	\N
160	PENDING	5	af5de0d5-05e2-4915-9a6c-3922da8f3c2a	2024-03-25 19:39:33.817062	\N	\N	commodo dolore pariatur
161	PENDING	5	6b9f7581-94bf-4643-afea-5b05fcab9589	2024-03-25 21:41:10.177725	\N	\N	no onion
151	ACCEPTED	112	0ae09254-56fe-49ca-803b-d779ee7eedb9	2024-03-21 11:19:15.595322	2024-03-21 11:36:52.091744	12	\N
168	DECLINED	9	f8ce26f0-67ad-4aff-aa9b-6f1c2cfcba13	2024-04-03 12:17:14.412475	2024-04-03 14:19:52.191488	13	\N
153	ACCEPTED	105	9c5cec89-9acc-435c-b0d9-28fc1beaec35	2024-03-22 00:04:16.132996	2024-04-03 15:07:57.806579	1	commodo dolore pariatur
169	DECLINED	9	78f99975-8c3b-482d-92e2-dca76662a1db	2024-04-03 12:17:56.990549	2024-04-03 14:19:52.194055	13	\N
170	DECLINED	9	643dba21-4d0e-4315-8bf5-f68e855f5d8f	2024-04-03 13:50:43.208449	2024-04-03 14:19:52.201919	13	\N
124	ACCEPTED	122	80180f43-b2f1-4436-bc5c-2d651d85bd4f	2024-03-06 12:31:39.478924	2024-04-03 17:37:35.362574	12	\N
131	ACCEPTED	108	052191c6-0304-4e81-87e6-f20cdc67bdd8	2024-03-14 12:30:08.99008	2024-04-14 23:38:04.043149	12	\N
134	ACCEPTED	108	33b73898-35f7-40f9-a018-372305c7ac71	2024-03-17 11:37:47.402167	2024-04-14 23:38:04.053627	12	\N
171	DECLINED	9	44dedaaf-1a09-4b8b-9181-8df3532bd9c1	2024-04-03 13:54:31.684978	2024-04-03 14:19:52.209421	13	\N
172	DECLINED	9	44a893bd-40bd-4669-9277-01639b470ce6	2024-04-03 13:57:53.137218	2024-04-03 14:19:52.211795	13	\N
173	DECLINED	9	6d258b29-7918-4a0d-b87f-3c7d6cbd80f7	2024-04-03 14:02:44.138756	2024-04-03 14:19:52.217328	13	\N
135	ACCEPTED	108	60afebf1-a24a-431b-bbd4-0e15d106a945	2024-03-17 13:31:01.911211	2024-04-14 23:38:04.063277	12	\N
136	ACCEPTED	108	46844940-7f82-4bd5-9f96-e90987e973f7	2024-03-18 17:12:26.921927	2024-04-14 23:38:04.075141	12	\N
137	ACCEPTED	108	5c5c3ba1-96d7-4154-b35e-0aeb5d2994c2	2024-03-18 17:14:16.359041	2024-04-14 23:38:04.084554	12	\N
174	DECLINED	9	205e1820-c89d-4bb8-8e60-28a2ddb997d5	2024-04-03 14:07:43.13931	2024-04-03 14:19:52.220335	13	\N
175	DECLINED	9	7fe7bbc3-1891-4ba2-bbf0-f727c0c7ad16	2024-04-03 14:08:21.885589	2024-04-03 14:19:52.238556	13	\N
178	DECLINED	9	d60074d2-9135-4e84-acab-c078b13a66fe	2024-04-03 14:13:13.011652	2024-04-03 14:19:52.262527	13	\N
138	ACCEPTED	108	e2123f59-82d0-42ad-a09f-aaa07d5bd032	2024-03-18 18:41:24.574843	2024-04-14 23:38:04.090166	12	\N
139	ACCEPTED	108	3045426b-139c-4c49-85b7-bf3cca043726	2024-03-18 18:46:55.625162	2024-04-14 23:38:04.096906	12	\N
140	ACCEPTED	108	fda37440-0451-4af3-8245-135c80bf992e	2024-03-18 18:52:48.597803	2024-04-14 23:38:04.104595	12	\N
141	ACCEPTED	108	692a4eb0-6f46-4c01-9fd7-e1d29f975089	2024-03-18 18:58:44.786613	2024-04-14 23:38:04.124991	12	\N
176	DECLINED	9	d5e09391-9858-4433-a272-d1def426e24b	2024-04-03 14:08:50.03009	2024-04-03 14:19:52.247046	13	\N
177	DECLINED	9	49caa850-a21e-4928-a8be-0c6098d7ccc5	2024-04-03 14:11:23.095364	2024-04-03 14:19:52.254119	13	\N
179	DECLINED	124	6242ef03-aa1c-4afa-9a61-f3bd8ace606c	2024-04-03 14:20:19.160033	2024-04-03 14:22:59.114113	13	\N
180	DECLINED	125	7cf4ece0-aac1-45dd-8b86-2b34a648978e	2024-04-03 14:23:07.715845	2024-04-03 14:37:11.596559	13	\N
181	DECLINED	126	6af9932d-071c-455a-b7ae-3e4e93a5b379	2024-04-03 14:37:16.160956	2024-04-03 14:38:47.135884	13	\N
182	DECLINED	127	0ba6bfbc-7912-4521-b708-0fc1f871dbe1	2024-04-03 14:38:51.948671	2024-04-03 14:40:53.891439	13	\N
215	ACCEPTED	186	69c2d629-3a8c-435c-8c1d-d423e212a4df	2024-04-05 11:02:46.621481	2024-04-05 11:02:47.184618	13	\N
183	DECLINED	128	d7931c98-5af6-482d-bb75-d97028c0f11b	2024-04-03 14:40:58.806761	2024-04-03 14:42:07.977665	13	\N
184	DECLINED	129	5ebe3da4-8e6e-422d-b2c3-d5e1926df86f	2024-04-03 14:42:12.663525	2024-04-03 14:43:53.034749	13	\N
216	DECLINED	188	5aaeccdc-dd9b-42f7-91d6-bb31ec8f2dc3	2024-04-05 11:07:28.270371	2024-04-05 11:07:28.82741	13	\N
185	DECLINED	130	a67c0cac-ee8d-4821-a6ae-812bbc71fa18	2024-04-03 14:43:57.750307	2024-04-03 14:45:24.149652	13	\N
186	DECLINED	131	a7b4e8bd-acc2-4283-b8a5-c77587223485	2024-04-03 14:45:28.966504	2024-04-03 14:55:36.196299	13	\N
217	ACCEPTED	188	52348c56-6956-4698-8de6-dd9179933eec	2024-04-05 11:07:31.393388	2024-04-05 11:07:31.892965	13	\N
187	DECLINED	132	bda6428c-9345-4dd7-bdf4-29732a91038b	2024-04-03 14:55:40.060184	2024-04-03 14:56:30.243952	13	\N
188	DECLINED	133	9bc6fb98-dc44-4715-bea1-c65e40795582	2024-04-03 14:56:34.148048	2024-04-03 14:57:16.100573	13	\N
218	DECLINED	190	9d001e37-a04b-41ce-8646-e7a36110ac0b	2024-04-05 11:08:34.322141	2024-04-05 11:08:34.89295	13	\N
189	DECLINED	134	666469e6-fa03-438c-96ae-e1b3f80ca807	2024-04-03 14:57:20.141778	2024-04-03 15:06:39.67813	13	\N
190	DECLINED	135	b680ad4b-1fb4-49cf-bc91-9d78459bdb26	2024-04-03 15:06:43.821812	2024-04-03 15:10:12.254363	13	\N
191	ACCEPTED	136	d840c480-1d79-4e98-91c4-e86ebc0f6342	2024-04-03 15:10:16.252257	2024-04-03 15:10:17.64402	13	\N
193	ACCEPTED	122	1c7e3568-5425-494f-8fef-d914ee57555a	2024-04-03 17:35:26.871508	2024-04-03 17:37:35.367932	12	\N
194	DECLINED	122	b1ee2206-139e-4c1a-87b2-44980703c0e9	2024-04-03 17:54:17.306327	2024-04-03 19:04:10.295308	12	\N
196	ACCEPTED	138	9f54fb7b-fa27-47ef-9d67-644bd402f574	2024-04-04 08:55:02.135686	2024-04-04 08:55:03.561424	13	\N
197	ACCEPTED	140	e94fc81f-1e63-4e10-a7b3-63508c9f94d9	2024-04-04 08:55:33.160511	2024-04-04 08:55:34.400624	13	\N
198	DECLINED	143	5fb04b84-6a43-4aba-9548-8883c7f39df5	2024-04-04 09:26:56.936688	2024-04-04 09:36:21.787354	13	\N
199	ACCEPTED	144	a62f889d-7467-454f-a100-b48c1f8ae994	2024-04-04 09:36:25.975555	2024-04-04 09:36:27.279734	13	\N
200	ACCEPTED	146	fd697928-9018-4afa-911a-d9501d7222bc	2024-04-04 09:37:48.820727	2024-04-04 09:37:49.42236	13	\N
201	ACCEPTED	148	68291612-68d4-4799-8aba-de79a74f3aa0	2024-04-04 09:38:12.182205	2024-04-04 09:38:12.798346	13	\N
202	ACCEPTED	150	a181cd6c-0bc7-467d-9072-db474c49fb1c	2024-04-04 09:38:22.479628	2024-04-04 09:38:23.774378	13	\N
203	ACCEPTED	155	217f420e-3b27-4b0a-a57d-4802015d29ec	2024-04-04 09:49:35.379111	2024-04-04 09:49:35.980493	13	\N
204	ACCEPTED	159	ff17ee6f-704b-4fd8-8c94-22af8a07a691	2024-04-04 09:49:51.025276	2024-04-04 09:49:52.225623	13	\N
205	ACCEPTED	165	ea7780eb-c567-4da9-b945-76927e08575e	2024-04-04 10:01:46.174409	2024-04-04 10:01:46.784675	13	\N
206	ACCEPTED	171	01081842-bb5d-40f9-9f61-edda5fa2b3c6	2024-04-04 10:02:07.041313	2024-04-04 10:02:08.228381	13	\N
207	ACCEPTED	173	adbfa38f-4697-43e8-979f-11c0c1186bd8	2024-04-04 10:06:00.722933	2024-04-04 10:06:01.293975	13	\N
208	ACCEPTED	179	9b438a47-1cbb-48f3-82f1-156c437e2e08	2024-04-04 10:06:23.670343	2024-04-04 10:06:24.937889	13	\N
209	ACCEPTED	181	d7b13cfe-d72f-4166-bc6e-77677dd0d75a	2024-04-05 10:43:12.277472	2024-04-05 10:43:13.782168	13	\N
219	ACCEPTED	190	d49f5f76-6a0c-4735-8bb7-ae1f311c5207	2024-04-05 11:08:37.536322	2024-04-05 11:08:38.073016	13	\N
210	ACCEPTED	183	8d5a8250-fdb9-4e3f-ad9a-331d4632e745	2024-04-05 10:54:02.230532	2024-04-05 10:54:06.029238	13	\N
211	ACCEPTED	183	891ba0dc-bf2c-4025-a8af-6611f879b2c7	2024-04-05 10:54:05.494649	2024-04-05 10:54:06.041639	13	\N
220	DECLINED	192	a67167ff-97a8-41ef-974c-8c78987a887e	2024-04-05 11:21:43.495779	2024-04-05 11:21:44.081326	13	\N
212	DECLINED	185	fc5352ab-d7d8-4c02-9845-a763f0f881a2	2024-04-05 10:54:47.089823	2024-04-05 11:02:37.425689	13	\N
213	DECLINED	185	49c2d98d-b2ea-455c-b8c0-7c36dc9a0d9f	2024-04-05 10:54:50.638274	2024-04-05 11:02:37.428238	13	\N
214	DECLINED	186	52593ce0-6cc4-47da-8df1-d80d0498d308	2024-04-05 11:02:43.230924	2024-04-05 11:02:43.809935	13	\N
221	ACCEPTED	192	5f8810f6-9d1f-4448-8f02-c56a36d765ce	2024-04-05 11:21:46.694304	2024-04-05 11:21:47.257344	13	\N
222	ACCEPTED	194	5cf062a0-c5ed-4220-80cd-dd1568a77c9d	2024-04-05 11:22:12.378355	2024-04-05 11:22:12.978903	13	\N
223	ACCEPTED	196	64a46139-9a7c-469d-a83b-7c296dbc8524	2024-04-05 11:23:39.210314	2024-04-05 11:23:39.824009	13	\N
224	ACCEPTED	198	8cc45936-72a5-42ef-b260-479a1420d430	2024-04-05 11:24:10.179252	2024-04-05 11:24:10.733531	13	\N
225	ACCEPTED	202	ee3cc320-3749-4010-8ad0-cce52b51ddcb	2024-04-05 11:24:25.864437	2024-04-05 11:24:27.300626	13	\N
226	ACCEPTED	206	197267ee-accb-4549-a4ae-0bcc51288ff9	2024-04-05 11:24:42.386632	2024-04-05 11:24:43.561674	13	\N
227	ACCEPTED	208	699085b0-b115-4ff2-bfb6-61985d4cc59d	2024-04-05 11:24:51.982863	2024-04-05 11:24:52.50449	13	\N
228	DECLINED	210	7c85bb5f-0a50-45ee-a3a6-878be74953ee	2024-04-05 11:25:00.91285	2024-04-05 11:25:01.417932	13	\N
229	ACCEPTED	210	5c77fb8a-fb34-4a98-8da2-0a9a8541f621	2024-04-05 11:25:03.774171	2024-04-05 11:25:04.3027	13	\N
195	ACCEPTED	122	6e7cdaf0-7f91-4203-b89a-c1af91d627b6	2024-04-03 19:04:16.185016	2024-04-05 17:35:29.968322	12	\N
231	ACCEPTED	212	167c1baa-3db1-4090-9edf-28ef582aa3ee	2024-04-07 05:01:22.850548	2024-04-07 05:01:23.447099	13	\N
232	ACCEPTED	214	630f651a-83ae-4f56-8b09-48424be1b2f2	2024-04-07 05:03:19.487982	2024-04-07 05:03:20.192548	13	\N
233	ACCEPTED	217	1a12e55a-7d42-4321-b656-e414240f7f15	2024-04-07 05:08:45.81024	2024-04-07 05:08:46.682315	13	\N
234	ACCEPTED	219	3f9e2a6c-9e61-41b2-bf8c-cd3e7283a643	2024-04-08 07:34:21.724502	2024-04-08 07:34:22.350668	13	\N
235	ACCEPTED	223	0483f1db-9b8f-4864-888e-830ccf524721	2024-04-08 07:34:38.293831	2024-04-08 07:34:39.779392	13	\N
236	ACCEPTED	227	b84a4959-713a-41cc-9d0a-d22195854f45	2024-04-08 07:34:55.991363	2024-04-08 07:34:57.223237	13	\N
237	ACCEPTED	229	90d53f31-b6dd-4f13-ab14-c12d09edae8c	2024-04-08 07:35:06.645738	2024-04-08 07:35:07.175287	13	\N
238	ACCEPTED	231	5762f266-2862-4484-b5ea-b9f4f6a0ea85	2024-04-08 07:35:16.41241	2024-04-08 07:35:17.222179	13	\N
239	DECLINED	233	6c6c8763-3130-4aac-b131-e7622b091095	2024-04-08 07:35:26.446535	2024-04-08 07:35:27.039973	13	\N
240	ACCEPTED	233	312e0771-e77d-4d16-95f3-88725bccee26	2024-04-08 07:35:29.588875	2024-04-08 07:35:30.104606	13	\N
241	ACCEPTED	235	7e5d7336-3e36-46a8-8c9b-72b090453966	2024-04-08 07:35:39.035584	2024-04-08 07:35:39.60429	13	\N
246	DECLINED	269	d0914640-aadf-4b8e-b617-26957afd1474	2024-04-08 07:44:52.749047	2024-04-08 07:44:53.05255	13	\N
242	DECLINED	240	16e41eb0-39ba-478b-8c7d-f1810346acff	2024-04-08 07:44:23.636734	2024-04-08 07:44:25.195166	13	\N
243	ACCEPTED	250	048166a7-042d-4a02-a0a8-974748272e3f	2024-04-08 07:44:33.92439	2024-04-08 07:44:34.801595	13	\N
244	ACCEPTED	254	22b046aa-a53a-496b-a236-54b3a60b2a48	2024-04-08 07:44:39.297971	2024-04-08 07:44:40.268171	13	\N
245	ACCEPTED	258	4f1ff23a-5cbf-42ae-97c5-97a9d5127b46	2024-04-08 07:44:42.605794	2024-04-08 07:44:43.328584	13	\N
247	DECLINED	283	89eecef8-af9a-4994-b896-b73e71e7f323	2024-04-08 07:46:00.435652	2024-04-08 07:52:31.550622	13	\N
248	DECLINED	285	008aa642-fe9e-4447-99c6-36547fa12c80	2024-04-08 07:52:35.561415	2024-04-08 07:54:22.620678	13	\N
249	DECLINED	287	9d8c8856-b485-478a-b7b2-bbfca1eeb2c4	2024-04-08 07:54:26.566423	2024-04-08 07:55:17.231515	13	\N
250	DECLINED	289	368180b4-3d68-46ad-8c86-9f7cc71950a6	2024-04-08 07:55:29.158289	2024-04-08 08:02:42.611129	13	\N
251	ACCEPTED	290	7550123b-525f-43a8-b738-25c3ba06c0fa	2024-04-08 08:02:46.277434	2024-04-08 08:02:47.526346	13	\N
252	ACCEPTED	292	ae4e3513-e453-4d3e-9c70-dbb7943e981b	2024-04-08 08:12:16.481579	2024-04-08 08:12:16.724011	13	\N
253	ACCEPTED	296	56729aea-5520-4e64-ae25-a63c074a322e	2024-04-08 08:12:23.519617	2024-04-08 08:12:24.216307	13	\N
254	ACCEPTED	300	7cff8b97-08cf-47bc-882e-3f8ce539eb52	2024-04-08 08:12:30.993225	2024-04-08 08:12:31.557119	13	\N
255	ACCEPTED	302	4684f698-c366-4d31-87d6-da91da5d5ff2	2024-04-08 08:12:35.355852	2024-04-08 08:12:35.58787	13	\N
256	ACCEPTED	304	cf5b8c73-4589-40b6-bb90-c1a0e3a789a4	2024-04-08 08:12:39.524758	2024-04-08 08:12:39.866355	13	\N
257	DECLINED	306	da424bd0-f375-41b3-85f0-b5bdc96a7c2d	2024-04-08 08:12:43.597605	2024-04-08 08:12:43.826618	13	\N
258	ACCEPTED	306	d662946d-db8e-40bd-bdfc-5a42d3b10365	2024-04-08 08:12:44.733949	2024-04-08 08:12:44.958793	13	\N
259	ACCEPTED	308	0cfa24f0-26b0-4368-a8db-8f6a6f991097	2024-04-08 08:12:48.705101	2024-04-08 08:12:48.931888	13	\N
260	ACCEPTED	315	b17b5d8b-2ff4-43ac-92a1-d48fc3e20a56	2024-04-08 08:23:53.884094	2024-04-08 08:23:54.131644	13	\N
192	ACCEPTED	108	107d7439-c650-49c1-96b1-672a1f684ffc	2024-04-03 16:39:13.309395	2024-04-14 23:38:04.200809	12	\N
230	ACCEPTED	112	6dcbd0f8-1fd5-4e8a-b0d9-ca0b1b7d0057	2024-04-05 17:34:25.681315	2024-04-14 23:40:35.706745	12	\N
261	ACCEPTED	319	b3a12717-72e9-456e-9fa6-de065a4abf7d	2024-04-08 08:24:00.637812	2024-04-08 08:24:01.410893	13	\N
262	ACCEPTED	323	0de232e7-e2c3-4152-8bfe-b021195c0d31	2024-04-08 08:24:08.488814	2024-04-08 08:24:09.118106	13	\N
263	ACCEPTED	325	819d9ac4-8aa6-4d31-8bf1-3f6def16d200	2024-04-08 08:24:13.08243	2024-04-08 08:24:13.314449	13	\N
264	ACCEPTED	327	9f5cfafc-05b3-4535-aad1-213297d718a8	2024-04-08 08:24:17.442637	2024-04-08 08:24:17.802482	13	\N
265	DECLINED	329	bf6e56b2-11f3-4b56-b2d5-1ed82fcd13bd	2024-04-08 08:24:21.696676	2024-04-08 08:24:21.927559	13	\N
266	ACCEPTED	329	a0fa2536-fa06-4d1c-84a5-8598ffd6f6ce	2024-04-08 08:24:22.842414	2024-04-08 08:24:23.080496	13	\N
267	ACCEPTED	331	aa3872ed-54d7-4acd-9350-c3ba4285ad24	2024-04-08 08:24:26.930967	2024-04-08 08:24:27.165533	13	\N
268	ACCEPTED	334	a83c1238-0722-4447-b904-029f541c4ad6	2024-04-08 08:26:25.84858	2024-04-08 08:26:26.089108	13	\N
269	ACCEPTED	338	80a1dee5-f8fa-4013-bc0d-0a1dece5a7b6	2024-04-08 08:26:33.004379	2024-04-08 08:26:33.703988	13	\N
270	ACCEPTED	342	5908b7fd-bf6c-421e-996d-d4e01c5e6af7	2024-04-08 08:26:40.459032	2024-04-08 08:26:41.066562	13	\N
271	ACCEPTED	344	36e2b419-9933-4eba-9460-41472ade21af	2024-04-08 08:26:44.943141	2024-04-08 08:26:45.169853	13	\N
272	ACCEPTED	346	ab617214-87d7-4eb9-96ce-0d132d78906a	2024-04-08 08:26:49.048709	2024-04-08 08:26:49.393579	13	\N
273	DECLINED	348	675fc09e-6294-4091-86bf-048bd4dd5e14	2024-04-08 08:26:53.117517	2024-04-08 08:26:53.342603	13	\N
274	ACCEPTED	348	9ae1542f-79eb-4112-aac7-23314e506f73	2024-04-08 08:26:54.221588	2024-04-08 08:26:54.448612	13	\N
275	ACCEPTED	350	18289793-e8bc-4ba4-995c-06c637e965fa	2024-04-08 08:26:58.23447	2024-04-08 08:26:58.476017	13	\N
276	ACCEPTED	355	0c4cecb7-a954-40bd-b9b6-12f718ef2cb2	2024-04-08 08:27:48.720764	2024-04-08 08:27:49.103089	13	\N
277	ACCEPTED	359	64263724-754f-4b47-a087-3166c7f49151	2024-04-08 08:27:59.439597	2024-04-08 08:28:00.475827	13	\N
278	ACCEPTED	363	cfe3e34d-c12b-4f8c-84fe-70674fd84c30	2024-04-08 08:28:11.36196	2024-04-08 08:28:12.205357	13	\N
279	ACCEPTED	365	73e7c040-d12e-40e8-b02c-ea9cc377c6f0	2024-04-08 08:28:18.223291	2024-04-08 08:28:18.585077	13	\N
280	ACCEPTED	367	f0750a69-6f61-4b7f-adfd-54019f4754a4	2024-04-08 08:28:24.713839	2024-04-08 08:28:25.254429	13	\N
281	DECLINED	369	8d58682b-0998-4ff7-a01c-aa2f3b523393	2024-04-08 08:28:31.235745	2024-04-08 08:28:31.616836	13	\N
282	ACCEPTED	369	cd77b87b-1f0f-4b7b-917c-51b66236ab19	2024-04-08 08:28:33.114602	2024-04-08 08:28:33.480379	13	\N
283	ACCEPTED	371	c91aca79-f7a2-439c-8cf5-948dae000ca8	2024-04-08 08:28:39.377931	2024-04-08 08:28:39.744484	13	\N
284	ACCEPTED	378	644077ee-13f6-4015-aee5-1df456db39b8	2024-04-08 08:57:16.97761	2024-04-08 08:57:17.230869	13	\N
285	ACCEPTED	382	11c95cc7-1280-4980-87e7-11fc2ebb368b	2024-04-08 08:57:23.562557	2024-04-08 08:57:24.251454	13	\N
286	ACCEPTED	386	15bac060-ed24-403d-80f6-493232bf7568	2024-04-08 08:57:31.141343	2024-04-08 08:57:31.73783	13	\N
287	ACCEPTED	388	c1a105c4-564f-409e-b973-7cb9bdf5936f	2024-04-08 08:57:35.547599	2024-04-08 08:57:35.779722	13	\N
288	ACCEPTED	390	9cb7d064-496f-404f-8343-4a6c96705490	2024-04-08 08:57:39.677894	2024-04-08 08:57:40.033418	13	\N
289	DECLINED	392	162fc2d0-ba5b-4304-9a9f-84986339fc55	2024-04-08 08:57:43.8334	2024-04-08 08:57:44.066288	13	\N
290	ACCEPTED	392	43a1b715-6ec2-4dfb-8feb-7ef68684185d	2024-04-08 08:57:44.977254	2024-04-08 08:57:45.211333	13	\N
291	ACCEPTED	394	f4ddb85a-6a8d-4b7d-b6f1-e0d150e39212	2024-04-08 08:57:48.970474	2024-04-08 08:57:49.206556	13	\N
292	ACCEPTED	397	3e4ce288-2ed2-4a86-abcb-2d754830c0cc	2024-04-08 09:07:16.102273	2024-04-08 09:07:16.492786	13	\N
293	ACCEPTED	401	5d70a984-8498-47fd-9606-b63742cd8802	2024-04-08 09:07:27.030154	2024-04-08 09:07:28.065923	13	\N
294	ACCEPTED	405	eb65af6a-4868-4b1c-bd5a-803af337d1ed	2024-04-08 09:07:38.781081	2024-04-08 09:07:39.656279	13	\N
295	ACCEPTED	407	a055dcb2-5fa4-44b0-919c-663d7c8c8623	2024-04-08 09:07:45.718409	2024-04-08 09:07:46.083303	13	\N
296	ACCEPTED	409	ca870604-c43d-4bb6-96cb-71a1baf9421e	2024-04-08 09:07:52.175254	2024-04-08 09:07:52.716908	13	\N
297	DECLINED	411	f60866d5-b448-4192-bb47-3040c0975fab	2024-04-08 09:07:58.641845	2024-04-08 09:07:59.007349	13	\N
298	ACCEPTED	411	c4fbb797-3e39-4650-90a1-7184239c4e1f	2024-04-08 09:08:00.538035	2024-04-08 09:08:00.897403	13	\N
299	ACCEPTED	413	f4c025df-8163-4a25-bf95-901399736a13	2024-04-08 09:08:06.884858	2024-04-08 09:08:07.242683	13	\N
300	ACCEPTED	418	450b0794-1ca8-4c03-bd23-bfe817e5b9a0	2024-04-08 09:09:18.484464	2024-04-08 09:09:18.840313	13	\N
301	ACCEPTED	422	a7517e40-0cee-4396-b37f-72fac18b8118	2024-04-08 09:09:28.315779	2024-04-08 09:09:29.244523	13	\N
302	ACCEPTED	426	75b38a33-8962-4b89-9181-d4129defb3fd	2024-04-08 09:09:38.957629	2024-04-08 09:09:39.754084	13	\N
303	ACCEPTED	428	7e4d9f8b-1f5c-413e-8836-92f888b3c3c3	2024-04-08 09:09:45.238267	2024-04-08 09:09:45.561038	13	\N
304	ACCEPTED	430	6aba46c9-912b-4cc7-98b2-753e50e0da80	2024-04-08 09:09:51.15595	2024-04-08 09:09:51.666617	13	\N
305	DECLINED	432	f1a94bf4-2b33-4856-9772-a96d49deb0db	2024-04-08 09:09:57.039437	2024-04-08 09:09:57.370856	13	\N
306	ACCEPTED	432	b08b5462-2832-426a-a73f-f99fc9d42730	2024-04-08 09:09:58.731583	2024-04-08 09:09:59.079022	13	\N
307	ACCEPTED	434	9496799b-95a9-4820-aa48-c95ad6019ca4	2024-04-08 09:10:04.723468	2024-04-08 09:10:05.091408	13	\N
308	ACCEPTED	439	46631af1-3033-4e70-80e7-d5396884f2bc	2024-04-08 09:12:40.113638	2024-04-08 09:12:40.486184	13	\N
309	ACCEPTED	443	f7275891-478f-413b-b16b-6f6a10cff27c	2024-04-08 09:12:50.828908	2024-04-08 09:12:51.837845	13	\N
310	ACCEPTED	447	7b641132-df25-45d2-b422-df20cbc4befc	2024-04-08 09:13:02.618156	2024-04-08 09:13:03.473723	13	\N
311	ACCEPTED	449	263b0226-abf1-4523-9b92-737d424a0a05	2024-04-08 09:13:09.467599	2024-04-08 09:13:09.826788	13	\N
312	ACCEPTED	451	18bb5d58-5fb5-4b94-8dc0-905cccc6394d	2024-04-08 09:13:15.943602	2024-04-08 09:13:16.493386	13	\N
313	DECLINED	453	abd7102d-8e88-45c3-aa3f-996ca73bf8ab	2024-04-08 09:13:22.386898	2024-04-08 09:13:22.747989	13	\N
314	ACCEPTED	453	10735148-deeb-4a30-bae4-26dd76370db7	2024-04-08 09:13:24.253634	2024-04-08 09:13:24.617884	13	\N
315	ACCEPTED	455	0b3d9e3c-663e-47f3-9edb-ef74c8b7c7f8	2024-04-08 09:13:30.54553	2024-04-08 09:13:30.945582	13	\N
316	ACCEPTED	462	c24f85bc-9573-4d8a-bed7-18baaddaa055	2024-04-08 09:35:47.351108	2024-04-08 09:35:47.916574	13	\N
317	ACCEPTED	466	a5133b9c-a6bb-4f05-a16c-1e90db638a0e	2024-04-08 09:35:59.062979	2024-04-08 09:36:00.334266	13	\N
318	ACCEPTED	470	19b5e9bf-f517-4ef3-9a2a-eef068eb4ecc	2024-04-08 09:36:12.254335	2024-04-08 09:36:13.222761	13	\N
319	ACCEPTED	472	11d7dc90-28ed-4677-a267-f138db32fd1d	2024-04-08 09:36:19.546826	2024-04-08 09:36:19.95725	13	\N
320	ACCEPTED	474	3f743e2a-428a-4cb0-b814-f500a63941db	2024-04-08 09:36:26.519517	2024-04-08 09:36:27.178583	13	\N
321	DECLINED	476	27da351a-7080-45fd-9529-301fe097c276	2024-04-08 09:36:33.42985	2024-04-08 09:36:33.838928	13	\N
322	ACCEPTED	476	b41265cc-0e11-4039-a5d0-83ff7898af9b	2024-04-08 09:36:35.443438	2024-04-08 09:36:35.834274	13	\N
323	ACCEPTED	478	1626955b-f710-40ff-a031-9ee0f32f04b4	2024-04-08 09:36:42.086611	2024-04-08 09:36:42.52104	13	\N
324	ACCEPTED	481	41b8c464-f4bd-4ebe-a3dd-4591227640c3	2024-04-09 09:08:41.113009	2024-04-09 09:08:41.752946	13	\N
325	ACCEPTED	485	23ec4bc2-da58-4c9e-ab56-5cbab37d9449	2024-04-09 09:08:54.327077	2024-04-09 09:08:55.628184	13	\N
326	ACCEPTED	489	b5d30d5e-2ddb-414f-8aad-119a24377628	2024-04-09 09:09:08.06539	2024-04-09 09:09:09.06524	13	\N
327	ACCEPTED	491	684fd2db-4a44-46cf-a323-9d5470b8498d	2024-04-09 09:09:15.675385	2024-04-09 09:09:16.124679	13	\N
328	ACCEPTED	493	c5802f6b-4aee-4bf3-bf2e-b9e34d552059	2024-04-09 09:09:22.758	2024-04-09 09:09:23.399305	13	\N
329	DECLINED	495	f4d6d425-2355-43ff-b1b1-dbdb4afacb6f	2024-04-09 09:09:29.761735	2024-04-09 09:09:30.175391	13	\N
330	ACCEPTED	495	2423e311-bfc7-40d1-9b9d-6a64a683a9bd	2024-04-09 09:09:31.768355	2024-04-09 09:09:32.164612	13	\N
331	ACCEPTED	497	859808d6-22bc-434d-9b64-3541fd2f25bb	2024-04-09 09:09:38.672795	2024-04-09 09:09:39.097044	13	\N
332	ACCEPTED	508	c740e191-1876-453c-b4f5-6c46dc22d76a	2024-04-09 09:43:21.884281	2024-04-09 09:43:22.549929	13	\N
333	ACCEPTED	512	dd1751f9-09eb-453a-af52-5d2f0ebc4179	2024-04-09 09:43:39.946948	2024-04-09 09:43:41.59971	13	\N
334	ACCEPTED	518	51f16a56-23b4-4ee2-93f1-b20f16789eaf	2024-04-09 09:44:05.052635	2024-04-09 09:44:05.642583	13	\N
335	ACCEPTED	520	c7c01fdb-b317-474f-9ad0-190d1a2ade3a	2024-04-09 09:44:15.703951	2024-04-09 09:44:16.616087	13	\N
336	DECLINED	522	f7a5d93f-7f7e-4acf-abb4-df5731308604	2024-04-09 09:44:25.906771	2024-04-09 09:44:26.500198	13	\N
337	ACCEPTED	522	aa08292a-fb64-4e91-b9ce-2b2d6a1f4362	2024-04-09 09:44:29.117736	2024-04-09 09:44:29.752251	13	\N
338	ACCEPTED	524	682f74ee-48cf-4680-bc47-14719937e43c	2024-04-09 09:44:39.18004	2024-04-09 09:44:39.796489	13	\N
339	ACCEPTED	530	45b08d59-22b5-46e1-a121-7c9b5d377304	2024-04-09 09:47:13.020043	2024-04-09 09:47:14.201588	13	\N
340	ACCEPTED	532	02205974-95b4-49cc-8473-db9810cab2a2	2024-04-09 10:25:31.868763	2024-04-09 10:25:32.492018	13	\N
341	ACCEPTED	536	b927c5bf-90e2-484f-8c68-90699645cb14	2024-04-09 10:25:49.138465	2024-04-09 10:25:50.661431	13	\N
342	ACCEPTED	540	9c32b872-1a65-437b-8d13-a04d53347c25	2024-04-09 10:26:06.998178	2024-04-09 10:26:08.237998	13	\N
343	ACCEPTED	542	74f4f8ce-fc40-4920-8cf8-e8a99e2efc7c	2024-04-09 10:26:17.778735	2024-04-09 10:26:18.362399	13	\N
344	ACCEPTED	544	1c728d82-d734-4871-8e62-05476323c97b	2024-04-09 10:26:27.810152	2024-04-09 10:26:28.701471	13	\N
345	DECLINED	546	527064ed-7206-4cee-b394-651493683e6b	2024-04-09 10:26:37.783744	2024-04-09 10:26:38.412876	13	\N
346	ACCEPTED	546	c6da421c-91d3-4f42-920c-801fbf11246e	2024-04-09 10:26:40.841278	2024-04-09 10:26:41.454965	13	\N
347	ACCEPTED	548	a5bca56d-4846-4ded-9f7f-bff60c567bae	2024-04-09 10:26:50.548587	2024-04-09 10:26:52.091731	13	\N
348	ACCEPTED	551	f086e30b-686c-4623-9943-c0a32bf84e4c	2024-04-09 10:27:22.683277	2024-04-09 10:27:23.889817	13	\N
349	ACCEPTED	553	43ea293d-40ef-4cd2-bf57-c6a84cf44587	2024-04-09 10:33:04.557765	2024-04-09 10:33:05.838633	13	\N
350	ACCEPTED	555	5f886819-8fc9-4290-8597-a19e7769fdaa	2024-04-09 10:34:09.909506	2024-04-09 10:34:11.147338	13	\N
351	ACCEPTED	557	e892825d-c6e2-40cf-9ecf-c5727f99e93b	2024-04-09 10:34:55.416627	2024-04-09 10:34:56.630758	13	\N
352	ACCEPTED	559	3f91cf29-2f46-406e-b48f-78a6239ed104	2024-04-09 10:44:47.077758	2024-04-09 10:44:47.641321	13	\N
353	ACCEPTED	563	8da0dcf0-65b4-4460-9ea2-12f888de80a5	2024-04-09 10:45:01.374676	2024-04-09 10:45:03.007556	13	\N
354	ACCEPTED	567	0521ee93-ef78-4151-8041-190948501066	2024-04-09 10:45:16.770539	2024-04-09 10:45:18.310869	13	\N
355	ACCEPTED	569	82d7dff1-6b28-4139-a9fb-f491f6f3382b	2024-04-09 10:45:27.309522	2024-04-09 10:45:27.858558	13	\N
356	ACCEPTED	571	e951e83a-39fa-41d4-bf98-75da524e83ab	2024-04-09 10:45:37.286609	2024-04-09 10:45:38.103083	13	\N
357	DECLINED	573	1f4bbb19-5b5b-4cf8-8003-70a2abd25b14	2024-04-09 10:45:48.08938	2024-04-09 10:45:48.658446	13	\N
358	ACCEPTED	575	4c610b4c-ee4c-494b-92f3-a7943fabbe05	2024-04-09 10:45:55.684772	2024-04-09 10:45:56.25822	13	\N
359	ACCEPTED	580	9778f4b5-c1a8-4368-bcac-20497d9a8b3e	2024-04-09 10:47:45.71458	2024-04-09 10:47:46.327988	13	\N
360	ACCEPTED	584	326c7cc5-8044-4821-bf04-5b92a959ac85	2024-04-09 10:48:03.072226	2024-04-09 10:48:04.651538	13	\N
361	ACCEPTED	588	da731ec2-2f83-40cd-9b09-7ba9ea70e578	2024-04-09 10:48:22.549259	2024-04-09 10:48:24.485028	13	\N
362	ACCEPTED	590	1c7b1344-479b-4240-8e4a-8eab78b0922f	2024-04-09 10:48:33.930433	2024-04-09 10:48:34.534889	13	\N
363	ACCEPTED	592	94c8deba-3f56-45a5-847c-bc29190a105c	2024-04-09 10:48:43.705633	2024-04-09 10:48:44.571928	13	\N
364	DECLINED	594	bb8b4d03-bd7c-4483-acc6-db0bca9b6513	2024-04-09 10:48:53.479434	2024-04-09 10:48:54.099541	13	\N
365	ACCEPTED	594	88d0b173-fdc6-4322-9cff-2e92c4a08316	2024-04-09 10:48:56.457532	2024-04-09 10:48:57.026429	13	\N
366	ACCEPTED	596	3aaaeb8b-18bf-4d8a-a0c7-f2fa909491ac	2024-04-09 10:49:06.066117	2024-04-09 10:49:06.616587	13	\N
367	ACCEPTED	599	fc7433ca-9a96-4110-90bb-2992d34e6e12	2024-04-09 11:00:56.858369	2024-04-09 11:00:57.451135	13	\N
368	ACCEPTED	603	34682285-4083-42e8-abee-639729bd824c	2024-04-09 11:01:14.064842	2024-04-09 11:01:15.554883	13	\N
369	ACCEPTED	607	4eebb8b9-72ad-4b08-925a-aba2c37c7929	2024-04-09 11:01:31.876242	2024-04-09 11:01:33.098779	13	\N
370	ACCEPTED	609	abc719af-94a7-4d61-b3b7-af1ff3189a89	2024-04-09 11:01:42.378063	2024-04-09 11:01:42.953368	13	\N
371	ACCEPTED	611	8d4c6f17-60c3-4aa5-ac7d-ffe848c3c294	2024-04-09 11:01:52.379175	2024-04-09 11:01:53.278196	13	\N
372	DECLINED	613	f7e46ef3-f83a-4071-b540-a77d578b05d1	2024-04-09 11:02:02.12937	2024-04-09 11:02:02.725367	13	\N
373	ACCEPTED	613	9e17608b-0d72-4523-80b0-97d5ca77bd28	2024-04-09 11:02:04.998436	2024-04-09 11:02:05.567621	13	\N
374	ACCEPTED	615	32530d4c-8942-4e6c-8c59-11b6498d1426	2024-04-09 11:02:14.751865	2024-04-09 11:02:15.348432	13	\N
375	ACCEPTED	618	e668bda3-e932-4a1c-9f2c-a3e460f5c541	2024-04-09 11:11:43.52213	2024-04-09 11:11:44.395082	13	\N
376	ACCEPTED	622	f247b25b-c999-4929-ac60-0ccadb3f11e3	2024-04-09 11:12:02.724307	2024-04-09 11:12:05.344685	13	\N
377	ACCEPTED	626	a740a98f-d06a-4bd6-9ef4-7fcd4233d822	2024-04-09 11:12:40.562374	2024-04-09 11:12:41.855095	13	\N
378	ACCEPTED	628	393cbd62-24b2-4c08-b432-803ec68ae80a	2024-04-09 11:12:51.794458	2024-04-09 11:12:52.558518	13	\N
379	ACCEPTED	630	c1c17ca2-d1d1-4af7-8281-e8dc468b6300	2024-04-09 11:13:01.743677	2024-04-09 11:13:02.591855	13	\N
380	DECLINED	632	478d4d2c-0787-4f0a-bddd-02b4515f6417	2024-04-09 11:13:11.803873	2024-04-09 11:13:12.364579	13	\N
381	ACCEPTED	632	c45e3406-a57c-498e-b549-5753344a7763	2024-04-09 11:13:14.747175	2024-04-09 11:13:15.382349	13	\N
382	ACCEPTED	634	d1e83d9e-708a-4ac6-93ef-8eea6a8aff77	2024-04-09 11:13:24.47583	2024-04-09 11:13:25.030208	13	\N
383	ACCEPTED	637	492066eb-d21f-4bad-a18a-d537c4970cc1	2024-04-09 11:35:52.048558	2024-04-09 11:35:52.646745	13	\N
384	ACCEPTED	641	0786341b-7bd1-4626-b87f-1d965706beb8	2024-04-09 11:36:09.578297	2024-04-09 11:36:11.04761	13	\N
385	ACCEPTED	645	9ac47f61-737a-4d18-9e89-174ddd1b8b44	2024-04-09 11:36:27.03406	2024-04-09 11:36:28.298156	13	\N
386	ACCEPTED	647	24929fce-e685-4e31-bcef-d1a9a75ffa8d	2024-04-09 11:36:38.095111	2024-04-09 11:36:38.650947	13	\N
387	ACCEPTED	649	bd00ea6f-cd5e-4d4a-8400-09ffd37be1eb	2024-04-09 11:36:48.067894	2024-04-09 11:36:48.936375	13	\N
388	DECLINED	651	95f3d92c-a545-46aa-8ca0-747680da678e	2024-04-09 11:36:58.280392	2024-04-09 11:36:58.855055	13	\N
389	ACCEPTED	651	4fac5623-2573-429f-b7dd-93ee6de00540	2024-04-09 11:37:01.192326	2024-04-09 11:37:01.765585	13	\N
390	ACCEPTED	653	b60c8d61-461f-476d-b79b-836a90c43cc9	2024-04-09 11:37:11.222961	2024-04-09 11:37:11.796343	13	\N
391	ACCEPTED	655	aacb8d74-f77f-49b7-9556-a5670e9808d7	2024-04-09 11:39:01.448924	2024-04-09 11:39:02.076594	13	\N
392	ACCEPTED	658	ba5c16e6-aee8-449a-933b-3247524bcd5c	2024-04-09 11:41:20.622183	2024-04-09 11:41:20.894532	13	\N
393	ACCEPTED	662	b2de10dc-aad7-47b5-b215-e0b4cbb1126c	2024-04-09 11:41:27.898495	2024-04-09 11:41:28.58547	13	\N
394	ACCEPTED	666	cff55cc6-1fec-4d94-b83a-4fc8fe6118e4	2024-04-09 11:41:35.447342	2024-04-09 11:41:36.032526	13	\N
395	ACCEPTED	668	516467fb-071c-4441-b548-22c733b6a22c	2024-04-09 11:41:39.975664	2024-04-09 11:41:40.221628	13	\N
396	ACCEPTED	670	27cb7a8d-5470-42b4-9e26-be93b2577990	2024-04-09 11:41:44.142914	2024-04-09 11:41:44.50121	13	\N
397	DECLINED	672	14250bb2-37f4-4dab-a451-b73200da983e	2024-04-09 11:41:48.327111	2024-04-09 11:41:48.555425	13	\N
398	ACCEPTED	672	3fa74b53-5e03-4601-a15a-7ebe699802f5	2024-04-09 11:41:49.442444	2024-04-09 11:41:49.668713	13	\N
399	ACCEPTED	674	a86e3ac2-20d9-4070-a294-b7aa1da5e961	2024-04-09 11:41:53.465628	2024-04-09 11:41:53.721553	13	\N
400	DECLINED	679	d9c8fc81-b6f3-41cf-8056-5d7fe28ffd14	2024-04-09 12:03:32.871323	2024-04-09 12:03:34.712396	13	\N
407	DECLINED	720	d0fa818d-f397-47b9-b906-d724e39b67bf	2024-04-09 12:09:02.725446	2024-04-09 12:09:03.304494	13	\N
401	DECLINED	685	6b0de626-8941-43d8-95c5-433c6b8ecc3c	2024-04-09 12:03:42.485085	2024-04-09 12:03:45.290772	13	\N
402	ACCEPTED	706	5add83ab-706d-4cff-85d2-2a234711976a	2024-04-09 12:07:56.562415	2024-04-09 12:07:57.175143	13	\N
403	ACCEPTED	710	e855181c-9798-494a-a199-eabd55540a37	2024-04-09 12:08:13.303464	2024-04-09 12:08:14.770305	13	\N
404	ACCEPTED	714	0d4e7285-86f3-4916-a136-861932104020	2024-04-09 12:08:31.139622	2024-04-09 12:08:32.386925	13	\N
405	ACCEPTED	716	3efa5fc4-bd74-4b9a-bebe-7a738529f8df	2024-04-09 12:08:42.18731	2024-04-09 12:08:42.777408	13	\N
406	ACCEPTED	718	96ca7da8-cf13-4264-aaca-2bdf83aa36d8	2024-04-09 12:08:52.541951	2024-04-09 12:08:53.35884	13	\N
408	ACCEPTED	720	1144bd60-d2e1-4fe1-be70-3b10349066bc	2024-04-09 12:09:05.72541	2024-04-09 12:09:06.288604	13	\N
409	ACCEPTED	722	d5927734-914f-44d2-a5f9-a8965aa310a5	2024-04-09 12:09:16.7192	2024-04-09 12:09:17.30783	13	\N
410	ACCEPTED	727	03c9f2de-5e3d-4d85-82dd-0ccc5d622a6d	2024-04-09 12:12:28.955335	2024-04-09 12:12:29.525814	13	\N
411	ACCEPTED	731	c9a2b726-2f1e-4160-b0a4-bef21cbb4e9f	2024-04-09 12:12:45.616948	2024-04-09 12:12:47.103852	13	\N
412	ACCEPTED	735	a39a1ab2-2eaa-4147-bda8-d310bfc6a87b	2024-04-09 12:13:04.106865	2024-04-09 12:13:05.349251	13	\N
413	ACCEPTED	737	f5016939-8590-4c2b-941b-56b524af4606	2024-04-09 12:13:15.503453	2024-04-09 12:13:16.101484	13	\N
414	ACCEPTED	739	de7e288f-9b25-4638-8bc7-bfc397377cc7	2024-04-09 12:13:26.675144	2024-04-09 12:13:27.590737	13	\N
415	DECLINED	741	7d72f97d-c8ca-4ca0-ba7f-308c7327ad36	2024-04-09 12:13:37.509615	2024-04-09 12:13:38.128559	13	\N
416	ACCEPTED	741	3938d7c2-25c5-43c5-a991-ca6ddf8160d5	2024-04-09 12:13:40.550178	2024-04-09 12:13:41.110871	13	\N
417	ACCEPTED	743	ca477f76-fe33-4664-a995-217c24396e66	2024-04-09 12:13:50.602681	2024-04-09 12:13:51.238764	13	\N
418	ACCEPTED	748	2b12d2a2-f00f-4784-93a7-264885289521	2024-04-09 12:18:10.100663	2024-04-09 12:18:10.37811	13	\N
419	ACCEPTED	752	4202f4a5-6f8a-4089-b614-0fe638d8a6d6	2024-04-09 12:18:17.897834	2024-04-09 12:18:18.64062	13	\N
420	ACCEPTED	756	56af6eaa-c2bb-45e0-b0dd-4d20ca218c6d	2024-04-09 12:18:25.903755	2024-04-09 12:18:26.550636	13	\N
421	ACCEPTED	758	3359becf-cb3b-4beb-aac6-5f032ece567c	2024-04-09 12:18:30.723918	2024-04-09 12:18:30.964209	13	\N
422	ACCEPTED	760	3adabf47-a432-426d-970d-78435a298f71	2024-04-09 12:18:35.107695	2024-04-09 12:18:35.4999	13	\N
423	DECLINED	762	15f85012-2ce5-4c42-8d92-3278361d7245	2024-04-09 12:18:39.561312	2024-04-09 12:18:39.816887	13	\N
424	ACCEPTED	762	8ca4705c-0139-4387-aacb-20abc55a869b	2024-04-09 12:18:40.804672	2024-04-09 12:18:41.07381	13	\N
425	ACCEPTED	764	6092fd36-7c2f-48e8-9144-20afa3655353	2024-04-09 12:18:45.089472	2024-04-09 12:18:45.346893	13	\N
426	ACCEPTED	769	dfff50cd-3b7e-407f-8a77-f4ece80436cd	2024-04-09 12:19:54.397032	2024-04-09 12:19:54.692686	13	\N
427	ACCEPTED	773	d2a21cad-24d8-44d2-bb5d-58ca7f11588c	2024-04-09 12:20:03.169425	2024-04-09 12:20:04.131861	13	\N
428	ACCEPTED	777	53ce1fe6-5ecb-494f-98c1-b16a464810d8	2024-04-09 12:20:12.457414	2024-04-09 12:20:13.153627	13	\N
429	ACCEPTED	779	8a3d7c5c-f812-45ef-92e5-9bb627c87cfc	2024-04-09 12:20:17.86938	2024-04-09 12:20:18.149062	13	\N
430	ACCEPTED	781	5febbbac-0625-4ef0-8730-60115e4ef161	2024-04-09 12:20:22.895834	2024-04-09 12:20:23.344717	13	\N
431	DECLINED	783	96150f66-4250-4c27-a87b-eb9ef369c238	2024-04-09 12:20:27.852621	2024-04-09 12:20:28.137325	13	\N
432	ACCEPTED	783	9959603b-a170-4d80-91ac-644addc2bc26	2024-04-09 12:20:29.241379	2024-04-09 12:20:29.537301	13	\N
433	ACCEPTED	785	e258b52b-e071-460b-b450-a0366bcd9bf7	2024-04-09 12:20:34.073395	2024-04-09 12:20:34.362675	13	\N
434	ACCEPTED	790	5c6f42ab-f9b0-432c-93bb-d83a83148368	2024-04-10 02:26:09.97102	2024-04-10 02:26:10.256374	13	\N
435	ACCEPTED	794	b91d7cad-8b87-4343-943d-8d8be40cb1ac	2024-04-10 02:26:17.75567	2024-04-10 02:26:18.522096	13	\N
436	ACCEPTED	798	facaba90-40dc-4131-83c5-0e1f64ef8ff3	2024-04-10 02:26:25.850046	2024-04-10 02:26:26.472484	13	\N
437	ACCEPTED	800	420f191f-08fd-4a18-bff2-59b62fa76aeb	2024-04-10 02:26:30.602899	2024-04-10 02:26:30.859115	13	\N
438	ACCEPTED	802	7f4fb4b9-2d0a-4a37-9c3a-8edd9d89fe2d	2024-04-10 02:26:34.960425	2024-04-10 02:26:35.342805	13	\N
439	DECLINED	804	09815f5f-f6cd-4b1f-8c49-362764782b68	2024-04-10 02:26:39.455682	2024-04-10 02:26:39.700334	13	\N
440	ACCEPTED	804	56433f41-60e4-4e29-9666-71850269cdfc	2024-04-10 02:26:40.623051	2024-04-10 02:26:40.8612	13	\N
441	ACCEPTED	806	f7dddd4d-a69a-434d-b5e9-6e5a19809c04	2024-04-10 02:26:44.998117	2024-04-10 02:26:45.246819	13	\N
442	ACCEPTED	813	74fb9d9b-7568-42b4-9e5d-3e85639bf18d	2024-04-10 10:56:36.563399	2024-04-10 10:56:36.835705	13	\N
443	ACCEPTED	817	d283dade-171d-4362-828b-e37c978cc58a	2024-04-10 10:56:43.832843	2024-04-10 10:56:44.584775	13	\N
444	ACCEPTED	821	4295d5b2-ede9-44d1-9eb9-4075a97c19aa	2024-04-10 10:56:51.687664	2024-04-10 10:56:52.286546	13	\N
445	ACCEPTED	823	00cbca8b-36af-4f66-bdf9-589432b75773	2024-04-10 10:56:56.281196	2024-04-10 10:56:56.518091	13	\N
446	ACCEPTED	825	1af766d1-36f4-4e0d-b1f6-fef78e21eb96	2024-04-10 10:57:00.478361	2024-04-10 10:57:00.847804	13	\N
447	DECLINED	827	c444dd17-ace4-4112-8e8d-15d102d250f9	2024-04-10 10:57:04.888745	2024-04-10 10:57:05.119211	13	\N
448	ACCEPTED	827	3eb4919c-b91b-46c9-bdea-a813ee71646b	2024-04-10 10:57:06.023358	2024-04-10 10:57:06.265609	13	\N
449	ACCEPTED	829	a2afa552-41bb-4713-a816-a34989878e73	2024-04-10 10:57:10.117444	2024-04-10 10:57:10.357361	13	\N
450	ACCEPTED	834	0f2f2aa4-a82a-4051-bf28-7f36503986ae	2024-04-10 11:00:08.02731	2024-04-10 11:00:08.293335	13	\N
451	ACCEPTED	838	47e365d9-b36f-4321-805b-ca48231ccdab	2024-04-10 11:00:15.792274	2024-04-10 11:00:16.555575	13	\N
452	ACCEPTED	842	b48039e2-d778-476c-9d08-b1fd093c64e5	2024-04-10 11:00:23.968304	2024-04-10 11:00:24.672446	13	\N
453	ACCEPTED	844	b4887b79-924c-4669-8cbc-3312964a4029	2024-04-10 11:00:28.958755	2024-04-10 11:00:29.205081	13	\N
454	ACCEPTED	846	046ab9fb-35d3-4a75-a58d-09c9697ca0e4	2024-04-10 11:00:33.338373	2024-04-10 11:00:33.721921	13	\N
455	DECLINED	848	804c931b-c7e0-45f9-af9c-faf25336590b	2024-04-10 11:00:37.760747	2024-04-10 11:00:38.018739	13	\N
456	ACCEPTED	848	7b9c23f8-0a26-4dbb-8cdb-d3916db9f24e	2024-04-10 11:00:38.950963	2024-04-10 11:00:39.197938	13	\N
457	ACCEPTED	850	4d7fe3a9-03c9-44b0-816b-25e548d1d8fe	2024-04-10 11:00:43.342086	2024-04-10 11:00:43.622044	13	\N
458	ACCEPTED	855	339f08c9-a25f-4db9-9fc2-b9cdedd7fcf0	2024-04-10 11:01:22.254224	2024-04-10 11:01:22.523686	13	\N
459	ACCEPTED	859	98dd44d0-3f36-40ba-a7a1-3bd1a8705eaa	2024-04-10 11:01:29.969326	2024-04-10 11:01:30.77584	13	\N
460	ACCEPTED	863	c83b67c4-4743-4a01-a921-1c17eb8d0f13	2024-04-10 11:01:37.921467	2024-04-10 11:01:38.545503	13	\N
461	ACCEPTED	865	27aa0d4b-a59a-43bc-b3db-64395d2ee26f	2024-04-10 11:01:42.680362	2024-04-10 11:01:42.932246	13	\N
462	ACCEPTED	867	87cb8b31-6f32-408a-90b5-5f1f19234277	2024-04-10 11:01:47.024006	2024-04-10 11:01:47.4031	13	\N
463	DECLINED	869	1ce10058-2447-414e-b5a1-ff0afabd4fb3	2024-04-10 11:01:51.356516	2024-04-10 11:01:51.598578	13	\N
464	ACCEPTED	869	2ff9a975-2235-40fa-a3bf-c31c056fe6a2	2024-04-10 11:01:52.513803	2024-04-10 11:01:52.752055	13	\N
465	ACCEPTED	871	131a6b5d-718d-4a19-b9fd-2e5dd4a4e074	2024-04-10 11:01:56.662733	2024-04-10 11:01:56.900821	13	\N
466	ACCEPTED	876	7d5886f1-3166-4235-bb45-e97bd6314b14	2024-04-10 11:05:59.796245	2024-04-10 11:06:00.104186	13	\N
467	ACCEPTED	880	de1ece1b-3f36-4cbe-b021-0c76ed3587e4	2024-04-10 11:06:08.26888	2024-04-10 11:06:09.086709	13	\N
468	ACCEPTED	884	63e56640-3c76-48ef-98f1-2b1147bcb107	2024-04-10 11:06:17.195654	2024-04-10 11:06:17.918402	13	\N
469	ACCEPTED	886	d864c4e8-0b64-4ab6-ad41-6d0645153646	2024-04-10 11:06:22.573736	2024-04-10 11:06:22.854595	13	\N
470	ACCEPTED	888	8e4350b9-f34e-4506-bf59-fdc977755046	2024-04-10 11:06:27.579895	2024-04-10 11:06:28.002814	13	\N
471	DECLINED	890	0657d5f0-4c59-40ae-a7e8-18b266a48b09	2024-04-10 11:06:32.601339	2024-04-10 11:06:32.91932	13	\N
472	ACCEPTED	890	3be8caf3-4f4b-4091-8591-679ca690abda	2024-04-10 11:06:34.103477	2024-04-10 11:06:34.372776	13	\N
473	ACCEPTED	892	c7ce1db0-b8be-4d64-a333-b3c27e87da21	2024-04-10 11:06:38.848155	2024-04-10 11:06:39.122323	13	\N
474	ACCEPTED	897	577f1c95-502f-4e19-8f02-99ae4117bff8	2024-04-10 11:08:30.705136	2024-04-10 11:08:30.985168	13	\N
475	ACCEPTED	901	d2c3bb1a-884c-40a5-977a-4beb3bb706b2	2024-04-10 11:08:39.08432	2024-04-10 11:08:39.908696	13	\N
476	ACCEPTED	905	a739205a-976b-4ea3-8eb3-535cc5f37334	2024-04-10 11:08:47.933538	2024-04-10 11:08:48.629876	13	\N
477	ACCEPTED	907	bbfa4c0d-da55-40b4-a4ce-b3cd075410d1	2024-04-10 11:08:53.226477	2024-04-10 11:08:53.496251	13	\N
478	ACCEPTED	909	f2532bf5-bc4a-4b0c-ab9b-d114b90675c2	2024-04-10 11:08:58.224311	2024-04-10 11:08:58.665773	13	\N
479	DECLINED	911	7af19517-9370-4682-8101-1147380cbf9e	2024-04-10 11:09:03.381005	2024-04-10 11:09:03.662728	13	\N
480	ACCEPTED	911	af0a46b6-dec4-459c-98b3-14159ed5d512	2024-04-10 11:09:04.740733	2024-04-10 11:09:05.017419	13	\N
481	ACCEPTED	913	a85537e4-3d5a-4463-a45e-74ba8904408e	2024-04-10 11:09:09.510886	2024-04-10 11:09:09.782068	13	\N
482	ACCEPTED	918	52d66e36-d0dd-417d-bdb0-2fb5d7a20d69	2024-04-10 11:12:30.23125	2024-04-10 11:12:30.618193	13	\N
483	ACCEPTED	922	3f94c5aa-6849-4bb1-9871-3849362bca77	2024-04-10 11:12:41.382568	2024-04-10 11:12:42.480215	13	\N
484	ACCEPTED	926	663d610d-8a8a-493e-ad58-eb2c6a2d7990	2024-04-10 11:12:53.695765	2024-04-10 11:12:54.614314	13	\N
485	ACCEPTED	928	2d7c4a70-bca0-49ea-bfbe-f0a51b1cb3b3	2024-04-10 11:13:01.074932	2024-04-10 11:13:01.467865	13	\N
486	ACCEPTED	930	62df8aab-cbac-4f2b-970f-b636049b1cd0	2024-04-10 11:13:07.811465	2024-04-10 11:13:08.381928	13	\N
487	DECLINED	932	2c5f3750-c75f-49b9-a163-de8bcdd81d08	2024-04-10 11:13:14.555646	2024-04-10 11:13:14.933503	13	\N
488	ACCEPTED	932	ef4cf685-ba00-4648-9b67-0430c34d7f21	2024-04-10 11:13:16.447651	2024-04-10 11:13:16.836951	13	\N
489	ACCEPTED	934	77d96cad-f195-452b-9e72-f5aa7f6d284f	2024-04-10 11:13:23.084331	2024-04-10 11:13:23.477359	13	\N
490	ACCEPTED	939	b9453e0e-e01b-4009-aa0d-4375f5462520	2024-04-10 11:19:23.823838	2024-04-10 11:19:24.41919	13	\N
491	ACCEPTED	943	b7a8a5db-b8f5-469a-88f3-a918ee05046d	2024-04-10 11:19:35.526228	2024-04-10 11:19:36.717332	13	\N
492	ACCEPTED	947	0b2362d1-9b2f-4d51-b8d4-9e373b9760ec	2024-04-10 11:19:47.012748	2024-04-10 11:19:48.065114	13	\N
493	ACCEPTED	949	2804b158-c2ba-4f3f-a755-f4b22f07b0a6	2024-04-10 11:19:53.778505	2024-04-10 11:19:54.136487	13	\N
494	ACCEPTED	951	255a03e4-9467-4020-846d-4c0c6ecea4a7	2024-04-10 11:19:59.728797	2024-04-10 11:20:00.312641	13	\N
495	DECLINED	953	d2e7fc9c-f63b-440c-9102-e976a11167ca	2024-04-10 11:20:05.966012	2024-04-10 11:20:06.325266	13	\N
496	ACCEPTED	953	1807bee6-1f97-40b2-9166-995d747d4b0f	2024-04-10 11:20:07.582028	2024-04-10 11:20:07.937668	13	\N
497	ACCEPTED	955	03608980-bfc5-4a84-808a-9e1c600be2e2	2024-04-10 11:20:13.238583	2024-04-10 11:20:13.575956	13	\N
498	ACCEPTED	960	cb98f374-8b14-48c7-a7ac-08371479c30b	2024-04-12 18:36:24.919662	2024-04-12 18:36:25.602135	13	\N
499	ACCEPTED	964	d2ecf1ee-7130-4e89-a842-0c29a789cb79	2024-04-12 18:36:36.81895	2024-04-12 18:36:37.955649	13	\N
500	ACCEPTED	968	3a1ad52b-50cb-49fc-839e-fea97e56cdc5	2024-04-12 18:36:48.024953	2024-04-12 18:36:49.001912	13	\N
501	ACCEPTED	970	136c6122-bec8-44e5-8384-6de41d319fb6	2024-04-12 18:36:54.756934	2024-04-12 18:36:55.125964	13	\N
502	ACCEPTED	972	e48dfd87-cbd0-4351-9054-8187c7e3113e	2024-04-12 18:37:00.807361	2024-04-12 18:37:01.410886	13	\N
503	DECLINED	974	2884e001-aa9f-4486-9e6c-e2f143cd7216	2024-04-12 18:37:06.780556	2024-04-12 18:37:07.143327	13	\N
504	ACCEPTED	974	2fd9ddd1-a51e-4e1b-81e4-1b981eb84a69	2024-04-12 18:37:08.425416	2024-04-12 18:37:08.788517	13	\N
505	ACCEPTED	976	367cd006-1647-469a-ba37-2755f5167ead	2024-04-12 18:37:14.200888	2024-04-12 18:37:14.55771	13	\N
506	ACCEPTED	105	f07fae46-f474-4ca6-92ae-1214ec41942d	2024-04-14 21:43:12.981115	2024-04-14 21:43:43.000175	2	Цун
508	DECLINED	981	805fca32-8b3c-42ca-9363-261bb849ec93	2024-04-14 23:06:20.861266	2024-04-14 23:27:11.315181	2	\N
509	DECLINED	981	42c99768-3067-446f-adae-d6308f326a97	2024-04-14 23:06:44.509779	2024-04-14 23:27:11.323491	2	\N
510	DECLINED	981	5eb1ebf2-13b8-45a4-8924-0d21c38e5961	2024-04-14 23:07:05.660144	2024-04-14 23:27:11.333162	2	\N
511	ACCEPTED	981	efdef276-4b25-421e-a0e7-debffd17d8c5	2024-04-14 23:27:50.869143	2024-04-14 23:28:23.901315	2	\N
512	ACCEPTED	981	d1a1ec80-1642-4bfa-97e9-b8ee18390b1a	2024-04-14 23:31:25.336666	2024-04-14 23:31:28.35252	5	\N
507	ACCEPTED	108	fe7c236d-ef25-474c-a72e-5854a4a4b30a	2024-04-14 23:04:10.29362	2024-04-14 23:38:04.210891	12	\N
513	ACCEPTED	981	cc102e48-700f-49e0-b4af-f7742acdb621	2024-04-14 23:31:36.596108	2024-04-14 23:31:43.35943	2	\N
142	ACCEPTED	108	04c13108-b46d-4e68-8cd2-33687e805694	2024-03-18 19:10:12.464705	2024-04-14 23:38:04.136304	12	\N
144	ACCEPTED	108	7be05fdd-2524-4e26-9690-a5d96778a614	2024-03-19 08:06:20.759592	2024-04-14 23:38:04.141693	12	\N
162	ACCEPTED	108	b4fea9da-6056-4b48-bf29-8868d8f873c8	2024-03-28 10:52:11.41001	2024-04-14 23:38:04.146212	12	\N
163	ACCEPTED	108	b140f0d6-6ab2-4eaa-ad1e-c9b98a2ea2ef	2024-03-28 12:01:44.280902	2024-04-14 23:38:04.154364	12	\N
164	ACCEPTED	108	2fce12fe-f5a0-42f3-9eae-4024e7d59f55	2024-03-29 09:53:28.602415	2024-04-14 23:38:04.164332	12	\N
165	ACCEPTED	108	eb2c1d25-9dd4-4909-9846-f9f1658d7f22	2024-04-02 21:35:04.783507	2024-04-14 23:38:04.176548	12	авпыавпаывфавыф
166	ACCEPTED	108	58ffa1c7-ae63-4ce5-8c8c-d64b61cac7cf	2024-04-02 21:35:27.556385	2024-04-14 23:38:04.185442	12	\N
167	ACCEPTED	108	2ea814c8-1cd4-4f15-bc5a-c9d5b5a8b277	2024-04-03 10:30:48.369143	2024-04-14 23:38:04.192587	12	Privet
514	ACCEPTED	108	116b0bb7-10c1-4829-8414-083ef12678f8	2024-04-14 23:37:32.018167	2024-04-14 23:38:04.218623	12	\N
515	DECLINED	108	80d1331f-584d-43d6-aa21-5088e2f7bced	2024-04-14 23:38:23.455239	2024-04-14 23:58:46.313003	12	\N
516	PENDING	112	9d1bd9a7-03d0-48e2-9e11-40546c001751	2024-04-15 00:00:18.115121	\N	\N	\N
517	PENDING	113	2d9f5acf-852e-40ce-8343-d7bacbe4bb83	2024-04-15 22:22:16.398557	\N	\N	\N
518	PENDING	116	679534e2-5257-4d94-8768-f0a53b36cd06	2024-04-15 22:22:26.067198	\N	\N	\N
519	PENDING	120	50302281-d0e0-43fd-8431-023153732cfd	2024-04-15 22:22:35.130385	\N	\N	\N
520	PENDING	122	69ef1c4f-077a-46f7-ae27-4e233feae0de	2024-04-15 22:36:53.287965	\N	\N	Зкшмсу
521	PENDING	122	d307401b-5dd1-49f5-a8fd-62830262a203	2024-04-15 22:38:42.00307	\N	\N	\N
522	ACCEPTED	982	6a14f2aa-d1d6-4ab4-9aa1-8026ee94bc7a	2024-04-22 15:27:13.828511	2024-04-22 15:27:14.172314	13	\N
523	ACCEPTED	986	bef50333-1276-4d40-88e5-47d8485f6f1f	2024-04-22 15:27:22.064572	2024-04-22 15:27:22.88788	13	\N
524	ACCEPTED	990	ab3b8363-b9d0-492f-a6cb-4e8851f8a804	2024-04-22 15:27:30.278055	2024-04-22 15:27:30.97335	13	\N
525	ACCEPTED	992	bf526775-1dee-4a44-a746-5d4d5f779c72	2024-04-22 15:27:35.377666	2024-04-22 15:27:35.664869	13	\N
526	ACCEPTED	994	89bb1643-8771-46f4-aab0-cd42303720e6	2024-04-22 15:27:39.930205	2024-04-22 15:27:40.345306	13	\N
527	DECLINED	996	18e9ffe2-de13-43d5-b607-6fd322aa9d86	2024-04-22 15:27:44.439924	2024-04-22 15:27:44.712368	13	\N
528	ACCEPTED	996	226f6508-29db-476d-9bfc-6815563a8baf	2024-04-22 15:27:45.650559	2024-04-22 15:27:45.899477	13	\N
529	ACCEPTED	998	7cc83cd8-e560-4a0c-ba9c-ac8cc5b002cf	2024-04-22 15:27:49.983471	2024-04-22 15:27:50.251182	13	\N
530	ACCEPTED	1003	c3bd9159-39ea-4a38-93bc-6267724eabe3	2024-04-23 02:13:43.386062	2024-04-23 02:13:43.967872	13	\N
531	ACCEPTED	1007	fd21109c-d85a-4dff-b7d4-6d13da03ebe6	2024-04-23 02:13:54.925894	2024-04-23 02:13:56.128471	13	\N
532	ACCEPTED	1011	4094a9b3-a294-4dc5-a335-0192c715526a	2024-04-23 02:14:06.364369	2024-04-23 02:14:07.337555	13	\N
533	ACCEPTED	1013	90047bd1-fa2c-4c5e-a4b0-2a8cf535c154	2024-04-23 02:14:13.02841	2024-04-23 02:14:13.410828	13	\N
534	ACCEPTED	1015	21208ad4-9965-4bf1-8331-faadb9304eb5	2024-04-23 02:14:18.990289	2024-04-23 02:14:19.550375	13	\N
535	DECLINED	1017	1908e3c3-a789-4455-83a5-6ba63f3040f1	2024-04-23 02:14:24.978811	2024-04-23 02:14:25.355813	13	\N
536	ACCEPTED	1017	5f0de15a-3ddf-47d4-8147-9a3d0944636c	2024-04-23 02:14:26.619334	2024-04-23 02:14:26.976108	13	\N
537	ACCEPTED	1019	e5eb6c0a-c5d7-4038-890b-313a00c1a79f	2024-04-23 02:14:32.308285	2024-04-23 02:14:32.66837	13	\N
538	ACCEPTED	1024	3f7b670c-0ff5-4c87-a11f-abd4770aa90c	2024-04-23 18:16:04.095459	2024-04-23 18:16:04.792942	13	\N
539	ACCEPTED	1028	be147771-2a28-4e11-a2cc-87dd22423f45	2024-04-23 18:16:17.35172	2024-04-23 18:16:18.685632	13	\N
540	ACCEPTED	1032	c2e5cdde-ec80-459d-9e92-6bd18690351d	2024-04-23 18:16:30.674959	2024-04-23 18:16:31.686208	13	\N
541	ACCEPTED	1034	57c37322-6907-4337-8158-df69662f8dd2	2024-04-23 18:16:38.324429	2024-04-23 18:16:38.748746	13	\N
542	ACCEPTED	1036	52aabbc5-ebf4-4f82-b7c8-36fdd6f8df2a	2024-04-23 18:16:45.384098	2024-04-23 18:16:46.017998	13	\N
543	DECLINED	1038	1526ee4b-3b19-4a8a-a2e6-4f067e5ada5f	2024-04-23 18:16:52.487058	2024-04-23 18:16:52.943252	13	\N
544	ACCEPTED	1038	15f22049-aece-4946-8b32-b3e6bc4f8fe9	2024-04-23 18:16:54.498457	2024-04-23 18:16:54.908496	13	\N
545	ACCEPTED	1040	f8ddc9c7-09e0-48c3-b54e-5d2cb16d2bfe	2024-04-23 18:17:01.377828	2024-04-23 18:17:01.852661	13	\N
546	ACCEPTED	1045	a6b276f2-c705-4ce0-83dc-047a50ce0eaf	2024-04-23 19:00:21.686021	2024-04-23 19:00:22.344102	13	\N
547	ACCEPTED	1049	c52ac6cd-31d2-43b9-9def-efb3bb637131	2024-04-23 19:00:33.661785	2024-04-23 19:00:34.914919	13	\N
548	ACCEPTED	1053	9bae807b-abd6-457e-a6a9-1645638a65c3	2024-04-23 19:00:44.968368	2024-04-23 19:00:45.810076	13	\N
549	ACCEPTED	1055	d824f5f1-d3ee-4652-873c-f6d31330bbcd	2024-04-23 19:00:51.21441	2024-04-23 19:00:51.57561	13	\N
550	ACCEPTED	1057	3900dd58-88f3-4c7d-9a5b-8d469715ed80	2024-04-23 19:00:56.922613	2024-04-23 19:00:57.476472	13	\N
551	DECLINED	1059	189dd0a0-d674-4935-8c04-7615656e10a3	2024-04-23 19:01:03.480386	2024-04-23 19:01:03.847646	13	\N
552	ACCEPTED	1059	367b7e8f-ba89-4273-9870-6dbbb4fb5dea	2024-04-23 19:01:05.136404	2024-04-23 19:01:05.48512	13	\N
553	ACCEPTED	1061	7a088b00-cc52-4d4b-a4f2-d185d83fece4	2024-04-23 19:01:10.768365	2024-04-23 19:01:11.134222	13	\N
554	PENDING	122	b3f08e77-b8e8-4cd9-98ab-b9b837df1146	2024-05-14 10:49:35.699131	\N	\N	\N
555	ACCEPTED	1068	dc74c2de-5780-4bd9-846d-148ea376a2b7	2024-06-16 07:21:10.6779	2024-06-16 07:21:11.201754	13	\N
556	ACCEPTED	1072	16262574-c4e2-415a-a2b3-948f90440357	2024-06-16 07:21:22.761804	2024-06-16 07:21:24.05536	13	\N
557	ACCEPTED	1076	aebfdcef-794a-4a33-8729-159ac38521f2	2024-06-16 07:21:36.112802	2024-06-16 07:21:37.081065	13	\N
558	ACCEPTED	1078	ecd61a6c-163b-4915-a140-d68165de217e	2024-06-16 07:21:43.914071	2024-06-16 07:21:44.37909	13	\N
559	ACCEPTED	1080	54bfe8b1-a330-4ee1-bb71-9fce3dc275e4	2024-06-16 07:21:51.144219	2024-06-16 07:21:51.832548	13	\N
560	DECLINED	1082	42379bf5-38db-42b8-9240-8160d90bd8a8	2024-06-16 07:21:58.260367	2024-06-16 07:21:58.696053	13	\N
561	ACCEPTED	1082	2d2fe431-2eea-48c7-87f9-7503e16f3aab	2024-06-16 07:22:00.260343	2024-06-16 07:22:00.693889	13	\N
562	ACCEPTED	1084	a953a815-5ecc-4019-89ed-5b34af1b248e	2024-06-16 07:22:07.155513	2024-06-16 07:22:07.610498	13	\N
563	ACCEPTED	1089	4654be9f-0cbf-472f-8e7d-15876f862383	2024-07-05 16:16:45.123661	2024-07-05 16:16:45.750248	13	\N
564	ACCEPTED	1093	746ec660-10b2-4ba1-becb-482874a1b54a	2024-07-05 16:16:55.004611	2024-07-05 16:16:56.248686	13	\N
565	ACCEPTED	1097	81ff86ee-8f3f-416e-9afe-9fe8e4f8fd02	2024-07-05 16:17:05.727731	2024-07-05 16:17:06.664707	13	\N
566	ACCEPTED	1099	a0353223-29fb-426e-ad1f-9113fefeaad6	2024-07-05 16:17:11.727251	2024-07-05 16:17:12.07648	13	\N
567	ACCEPTED	1101	7254b1b5-3a15-4eeb-a46b-73e91f9e09fa	2024-07-05 16:17:17.240066	2024-07-05 16:17:17.788498	13	\N
568	DECLINED	1103	46712633-e838-43a6-9f0a-2ffcf4fcb69d	2024-07-05 16:17:22.352559	2024-07-05 16:17:22.693495	13	\N
569	ACCEPTED	1103	6a3d3e4e-1894-412f-b11f-d020015c64dc	2024-07-05 16:17:23.733925	2024-07-05 16:17:24.090667	13	\N
570	ACCEPTED	1105	fa5e1afe-3a29-4202-966c-34e3e806a888	2024-07-05 16:17:28.607139	2024-07-05 16:17:28.955158	13	\N
571	PENDING	117	a60e41f0-9738-4dd7-85b4-4b6a69fe67c5	2024-07-08 12:07:10.631354	\N	\N	\N
572	PENDING	116	bfc3194d-615f-4038-a4ff-b3c69e35e9bc	2024-07-08 12:09:43.030725	\N	\N	\N
573	PENDING	116	c4f66132-283b-466b-8e56-e91cdc6b3142	2024-07-08 12:10:20.600329	\N	\N	\N
575	ACCEPTED	981	9f4065a8-52d0-486f-8c01-1b5479f4f34d	2024-07-18 06:29:27.241072	2024-07-18 06:30:06.863151	1	no onion
576	ACCEPTED	981	220296d7-d174-4c18-99cd-1388120d7e6f	2024-07-18 06:30:18.342345	2024-07-18 06:30:53.967144	1	no onion
577	ACCEPTED	981	ba0e7897-ccd7-41a2-a4e1-2f903fd4c80c	2024-07-18 06:30:31.971238	2024-07-18 06:30:53.973979	1	no onion
578	ACCEPTED	981	82884e2d-254b-4996-b6fb-ae7cae796c19	2024-07-18 06:30:47.010273	2024-07-18 06:30:53.979573	1	no onion
579	ACCEPTED	981	f5df9f3c-5720-4ae2-9437-03689748d7fc	2024-07-18 06:30:58.391098	2024-07-18 06:31:08.078113	1	no onion
580	DECLINED	981	4bd6eb3d-b5c5-4a18-9476-e0b2c68b87a8	2024-07-18 06:31:10.326955	2024-07-18 17:33:21.492588	1	no onion
581	DECLINED	981	aaac46a6-3213-45e1-964e-451ba623d8b5	2024-07-18 06:34:02.723949	2024-07-18 17:33:21.501458	1	no onion
582	DECLINED	981	d81baad5-0b29-423f-8d0f-aa92c865a6ec	2024-07-18 06:34:14.075799	2024-07-18 17:33:21.521966	1	no onion
583	DECLINED	981	35cd2013-cdd8-4236-9606-1ab98e7cf2e0	2024-07-18 09:41:18.357199	2024-07-18 17:33:21.531445	1	no onion
584	DECLINED	981	d8861479-ca95-43d4-98a2-d9f4c3f91886	2024-07-18 09:43:23.912699	2024-07-18 17:33:21.546045	1	no onion
585	DECLINED	981	5fb7656f-c91f-422c-8eed-39846091da68	2024-07-18 09:46:07.561973	2024-07-18 17:33:21.556566	1	no onion
586	DECLINED	981	687518c2-321d-41e4-9a51-bb2917f37ae9	2024-07-18 09:47:10.493548	2024-07-18 17:33:21.567769	1	no onion
587	DECLINED	981	31c055a6-036e-47dd-bdf5-b83b42778eee	2024-07-18 10:35:10.031555	2024-07-18 17:33:21.580713	1	no onion
588	DECLINED	981	4249e86c-af7f-4da8-9946-ced2c153a283	2024-07-18 10:35:18.151293	2024-07-18 17:33:21.584538	1	no onion
589	DECLINED	981	fe65dba3-8be3-4dd5-9855-4da87249856c	2024-07-18 10:36:54.748651	2024-07-18 17:33:21.592522	1	no onion
590	DECLINED	981	e7470ec8-469a-4b55-b3b1-d81d7304e307	2024-07-18 10:37:28.83746	2024-07-18 17:33:21.596953	1	no onion
591	DECLINED	981	a4e0825f-34b4-40de-b822-c9a3867402c4	2024-07-18 10:45:56.938171	2024-07-18 17:33:21.601258	1	no onion
592	DECLINED	981	deb13967-2425-44df-a27d-c68912cfb0bc	2024-07-18 20:07:05.664466	2024-07-18 17:33:21.609625	1	no onion
593	DECLINED	981	4966ea07-3925-4675-9501-fbedf39e5eef	2024-07-18 20:07:18.356332	2024-07-18 17:33:21.617622	1	no onion
594	DECLINED	981	86446efe-e3b4-4156-b026-13c3e75d3545	2024-07-18 20:07:23.813585	2024-07-18 17:33:21.620648	1	no onion
595	DECLINED	981	7a73850b-4a06-4cce-b076-f0e26f8221de	2024-07-18 20:07:33.606681	2024-07-18 17:33:21.626384	1	no onion
596	DECLINED	981	86557177-5822-4ca2-b8e1-e21fa4bf498f	2024-07-18 20:16:13.546427	2024-07-18 17:33:21.630476	1	no onion
597	DECLINED	981	9839ac02-af50-40d7-b851-67a120b10f07	2024-07-18 20:16:19.275246	2024-07-18 17:33:21.637561	1	no onion
598	DECLINED	981	be1298b4-bfd5-4ca8-9eb0-5934edbaabca	2024-07-18 20:33:15.611196	2024-07-18 17:33:21.642642	1	no onion
599	ACCEPTED	981	1176cf47-40b2-4664-bc4b-978aad50d75f	2024-07-18 20:40:53.471107	2024-07-18 17:46:49.092739	1	no onion
600	ACCEPTED	981	bef905ec-5c55-4705-964e-9b64b7b10b2f	2024-07-18 20:41:02.137292	2024-07-18 17:46:49.099338	1	no onion
601	ACCEPTED	981	7fb94463-651a-4ad3-9823-b3ff16ab5bdb	2024-07-18 20:45:44.132901	2024-07-18 17:46:49.104367	1	no onion
602	ACCEPTED	981	649014b0-6803-4b2c-b333-22e61d45362a	2024-07-18 20:45:54.653854	2024-07-18 17:46:49.109608	1	no onion
603	ACCEPTED	981	7dc57d48-8f49-4d41-a829-8dd72d40f44e	2024-07-18 20:46:38.06339	2024-07-18 17:46:49.114558	1	no onion
604	ACCEPTED	981	103335d0-7b03-437b-a8ca-9f0563c0f3e9	2024-07-18 20:46:54.664956	2024-07-18 18:55:37.692436	2	no onion
605	ACCEPTED	981	6ab3498e-ffff-4c72-88c1-95987561e1be	2024-07-18 20:47:50.11432	2024-07-18 18:55:37.697194	2	no onion
606	ACCEPTED	981	f12396c7-4be1-477e-9386-5de37646d192	2024-07-18 20:48:31.598657	2024-07-18 18:55:37.701103	2	no onion
607	ACCEPTED	981	bae95247-0a89-4012-b6ae-f061cab620eb	2024-07-18 20:48:45.308455	2024-07-18 18:55:37.704848	2	no onion
608	ACCEPTED	981	2471e06e-53af-4cdc-a13b-2c5927b32293	2024-07-18 20:49:18.162912	2024-07-18 18:55:37.7149	2	no onion
609	ACCEPTED	981	f502d701-0b69-4a77-a233-d5b4d988be01	2024-07-18 20:50:09.961003	2024-07-18 18:55:37.738478	2	no onion
610	ACCEPTED	981	033f56d9-9735-4eff-8851-60231f2dd4d9	2024-07-18 21:53:34.506196	2024-07-18 18:55:37.755586	2	no onion
614	ACCEPTED	1108	ccb53ef3-9c74-4e7b-a307-d60c3e08fb4f	2024-07-18 19:28:29.348719	2024-07-18 19:28:30.407464	13	\N
615	ACCEPTED	1112	97e6960a-f41b-47c7-bd78-f46c4b9e5c30	2024-07-18 19:28:45.094892	2024-07-18 19:28:46.680338	13	\N
616	ACCEPTED	1116	6352a4f4-84c9-44ef-82f0-6f990a84a007	2024-07-18 19:28:59.260864	2024-07-18 19:29:00.325006	13	\N
617	ACCEPTED	1118	0bc2624f-8e01-422e-9039-b8de88660c95	2024-07-18 19:29:07.411946	2024-07-18 19:29:07.849574	13	\N
618	ACCEPTED	1120	6eaf9b83-ed79-47fe-94ee-b43dae2e4588	2024-07-18 19:29:15.162085	2024-07-18 19:29:15.970804	13	\N
619	DECLINED	1122	e402ab4d-360e-4463-92c3-12694998e2fc	2024-07-18 19:29:22.668118	2024-07-18 19:29:23.157186	13	\N
620	ACCEPTED	1122	efab999d-282b-46d2-beff-bb3dc6a60b65	2024-07-18 19:29:24.745785	2024-07-18 19:29:25.203821	13	\N
621	ACCEPTED	1124	37d5ef75-2903-42db-b768-8bf2ad22a63b	2024-07-18 19:29:32.117104	2024-07-18 19:29:32.580489	13	\N
613	ACCEPTED	981	ee1907b4-c7fd-4b63-93a5-1a5c2a451fd3	2024-07-18 19:28:28.514478	2024-07-18 19:29:42.063683	2	no onion
611	ACCEPTED	981	d8f326aa-2157-49f2-899e-fcb1eedbfffe	2024-07-18 22:11:15.324926	2024-07-18 19:29:42.097203	2	no onion
612	ACCEPTED	981	b6bfef4b-a1a0-42e2-8a5c-b0b145efe5e5	2024-07-18 22:11:27.503315	2024-07-18 19:29:42.114978	2	no onion
622	ACCEPTED	981	a00c285f-9a27-4646-bffa-e23b4564f4d3	2024-07-18 19:29:59.615438	2024-07-18 19:31:03.741131	1	no onion
623	ACCEPTED	981	921aa095-65fc-4e45-b7a2-667411f0406a	2024-07-18 19:30:19.190887	2024-07-18 19:31:03.750196	1	no onion
624	ACCEPTED	981	11937d48-abb6-41b2-98cf-70f3ab2998fd	2024-07-18 19:30:47.27389	2024-07-18 19:31:03.762821	1	no onion
625	ACCEPTED	981	fed03d58-7d86-4f32-9414-b53d74121c13	2024-07-18 19:30:52.08379	2024-07-18 19:31:03.773319	1	no onion
626	ACCEPTED	981	5cafb93c-72a4-403a-bd4a-98f0069b3298	2024-07-18 19:31:23.20092	2024-07-18 19:33:11.036639	1	no onion
627	ACCEPTED	981	73804b8e-b45c-4d90-8de7-6ddc0f217daf	2024-07-18 19:31:23.755789	2024-07-18 19:33:11.042237	1	no onion
628	ACCEPTED	981	32e5fb0d-2de4-4b8c-ae3c-4f9a4ccd2194	2024-07-18 19:51:25.539038	2024-07-18 19:51:57.272398	1	no onion
629	ACCEPTED	981	cbc9f768-3001-48c4-a3ca-5360c4b79443	2024-07-18 19:51:43.13482	2024-07-18 19:51:57.311536	1	no onion
630	DECLINED	981	cf09e184-5305-4fdd-a6c2-c7a14264cf11	2024-07-18 19:52:07.835651	2024-07-18 19:52:21.433519	2	no onion
631	ACCEPTED	1129	44cfea91-700e-4d0f-8107-0dd526e16e8f	2024-07-19 07:24:46.355056	2024-07-19 07:24:47.105165	13	\N
632	ACCEPTED	1133	a104a204-4389-4bf7-b1a7-90f49f0c6419	2024-07-19 07:24:59.913215	2024-07-19 07:25:01.422796	13	\N
633	ACCEPTED	1137	73191298-98b9-4e22-bdc5-3cb29275aeb2	2024-07-19 07:25:13.316836	2024-07-19 07:25:14.433018	13	\N
634	ACCEPTED	1139	ddb43529-83a4-45d7-8d1d-f9aacc5042ef	2024-07-19 07:25:20.454386	2024-07-19 07:25:20.856842	13	\N
635	ACCEPTED	1141	944dc9d4-52d3-461d-a418-c2da7f853ae3	2024-07-19 07:25:26.953346	2024-07-19 07:25:27.570104	13	\N
636	DECLINED	1143	221817a4-99ce-4628-8590-fd8928ad78c7	2024-07-19 07:25:33.447707	2024-07-19 07:25:33.860976	13	\N
637	ACCEPTED	1143	f3e1be0e-5aaa-4261-82fa-b13007b5f364	2024-07-19 07:25:35.182646	2024-07-19 07:25:35.572543	13	\N
638	ACCEPTED	1145	e9fe8f55-0bbc-4619-83dd-4745d648c7f6	2024-07-19 07:25:41.425004	2024-07-19 07:25:41.875408	13	\N
639	ACCEPTED	1150	7c73df83-1cf3-4595-af10-5902a13b4205	2024-08-01 14:29:29.802857	2024-08-01 14:29:30.276102	13	\N
640	ACCEPTED	1154	aadea17a-9c58-4d00-9e6e-4b8f45f29a1f	2024-08-01 14:29:39.293362	2024-08-01 14:29:40.327059	13	\N
641	ACCEPTED	1158	450e7180-2d8b-44ec-b721-48b525910841	2024-08-01 14:29:49.18849	2024-08-01 14:29:49.960741	13	\N
642	ACCEPTED	1160	2bab7794-32fd-4370-aa48-2516b6daddfe	2024-08-01 14:29:55.027898	2024-08-01 14:29:55.354014	13	\N
643	ACCEPTED	1162	4930ed9f-21f7-41ad-ae3c-c09c73cf16f7	2024-08-01 14:30:00.518295	2024-08-01 14:30:01.086004	13	\N
644	DECLINED	1164	2d62b755-0f32-4efa-b6de-ca4f225b509b	2024-08-01 14:30:06.463027	2024-08-01 14:30:06.796101	13	\N
645	ACCEPTED	1164	fa2fa927-be01-4e17-80c9-e22268f5de2b	2024-08-01 14:30:07.926139	2024-08-01 14:30:08.295089	13	\N
646	ACCEPTED	1166	bdc12ac9-9a8f-41bb-a518-304f99a734d5	2024-08-01 14:30:13.280259	2024-08-01 14:30:13.616525	13	\N
647	ACCEPTED	1173	ebf8101f-af2f-4369-9c77-7a3041c6d226	2024-08-01 14:34:48.564584	2024-08-01 14:34:48.973522	13	\N
648	ACCEPTED	1177	ca8788d4-7146-45c5-be3f-e13614566aa1	2024-08-01 14:34:59.496102	2024-08-01 14:35:00.831794	13	\N
649	ACCEPTED	1181	07c26da3-8f38-4505-90ef-347afdc35cbe	2024-08-01 14:35:12.618095	2024-08-01 14:35:13.534059	13	\N
650	ACCEPTED	1183	7f01babc-4d23-44e8-82f7-4c34af1b08f2	2024-08-01 14:35:20.126279	2024-08-01 14:35:20.545001	13	\N
651	ACCEPTED	1185	82ffc75c-5770-48f2-a087-b368f8a616e8	2024-08-01 14:35:27.060035	2024-08-01 14:35:27.712687	13	\N
652	DECLINED	1187	e973f73c-8793-4c18-b2ca-8e6e9cc81fb2	2024-08-01 14:35:33.969815	2024-08-01 14:35:34.371758	13	\N
653	ACCEPTED	1187	987ef09d-41d8-4202-977a-28af785a6427	2024-08-01 14:35:35.929699	2024-08-01 14:35:36.330814	13	\N
654	ACCEPTED	1189	d0ba21bd-5465-47a6-8d2c-cf5eb0a0f187	2024-08-01 14:35:42.993974	2024-08-01 14:35:43.428769	13	\N
655	ACCEPTED	1192	e8314936-eb8e-4101-9621-44bfdcf1583b	2024-08-01 14:39:55.01707	2024-08-01 14:39:55.365976	13	\N
656	ACCEPTED	1196	0aca185f-7582-4013-b0fa-704edb7ceb4d	2024-08-01 14:40:04.354054	2024-08-01 14:40:05.313969	13	\N
657	ACCEPTED	1200	5685f571-47be-4ee7-b5d1-e04641a9c581	2024-08-01 14:40:13.996972	2024-08-01 14:40:14.751333	13	\N
658	ACCEPTED	1202	3132c233-ede9-4913-beff-f4853561e34d	2024-08-01 14:40:19.634465	2024-08-01 14:40:19.942345	13	\N
659	ACCEPTED	1204	057ece6b-c4b9-47f5-835e-4e25b7967295	2024-08-01 14:40:24.845474	2024-08-01 14:40:25.311285	13	\N
660	DECLINED	1206	7542877a-22e5-4b6f-8b29-3e45e7ad161d	2024-08-01 14:40:30.077656	2024-08-01 14:40:30.413495	13	\N
661	ACCEPTED	1206	f3589543-f2a6-4229-8bde-dde4ada9eb88	2024-08-01 14:40:31.508757	2024-08-01 14:40:31.812319	13	\N
662	ACCEPTED	1208	d7d81be1-d998-40a6-825b-b6805a75f07f	2024-08-01 14:40:36.452326	2024-08-01 14:40:36.754627	13	\N
663	ACCEPTED	1213	ed09bae0-4b1c-4714-8787-fee9828eda1a	2024-08-01 15:14:50.87544	2024-08-01 15:14:51.259156	13	\N
664	ACCEPTED	1217	681a2978-9ecc-49c5-8d80-7deaab5a311c	2024-08-01 15:15:00.587397	2024-08-01 15:15:01.654797	13	\N
665	ACCEPTED	1221	f7df433d-0967-44ef-bc3e-6c6ac84b23ea	2024-08-01 15:15:11.438263	2024-08-01 15:15:12.236621	13	\N
666	ACCEPTED	1223	443b5613-86c8-46fd-ae22-4ebf91207142	2024-08-01 15:15:17.75518	2024-08-01 15:15:18.084837	13	\N
667	ACCEPTED	1225	c444387d-c46f-4f73-a9e3-642d5f872275	2024-08-01 15:15:23.404862	2024-08-01 15:15:23.940484	13	\N
668	DECLINED	1227	77b7b54a-e4ce-4804-89cc-1bf335e14163	2024-08-01 15:15:29.055222	2024-08-01 15:15:29.416552	13	\N
669	ACCEPTED	1227	d15549e0-cce4-484c-840e-07a5e8d9ebbf	2024-08-01 15:15:30.631141	2024-08-01 15:15:30.953724	13	\N
670	ACCEPTED	1229	1d0a3b4e-9a16-4a11-a48c-d02a39c93420	2024-08-01 15:15:36.129643	2024-08-01 15:15:36.466753	13	\N
671	PENDING	117	76d78dfd-c167-4e96-8eb7-6b814d3936e4	2024-08-06 15:22:49.334354	\N	\N	\N
672	PENDING	117	77b5ca4e-d5a9-4cd1-a507-8259ba1daf21	2024-08-06 15:23:36.427886	\N	\N	\N
673	PENDING	117	3fb58b93-01eb-4f89-8124-9475c1216e3b	2024-08-06 15:23:46.178194	\N	\N	\N
674	PENDING	117	af4f0b4d-dcb4-44a5-b9aa-c35b4b09f599	2024-08-06 15:25:33.060878	\N	\N	\N
675	PENDING	981	16964f4a-f942-48a5-87fc-303420471fac	2024-08-06 15:42:31.895181	\N	\N	no onion
676	PENDING	981	c52743ab-ad74-437a-a5ba-ac3167f70df2	2024-08-06 15:42:37.338386	\N	\N	no onion
677	PENDING	981	e66e5f5d-63b0-4f38-ab8d-b18935430832	2024-08-06 15:42:46.856108	\N	\N	no onion
678	PENDING	117	34c3070c-9784-43cc-a8c8-f8a5c30368e6	2024-08-06 15:58:54.969829	\N	\N	\N
679	PENDING	117	f3541281-3ebc-4167-ab56-d64c57cd69c1	2024-08-06 15:59:08.843282	\N	\N	\N
680	PENDING	117	1f58f701-ae09-465f-842f-3502fbbc1341	2024-08-06 16:10:51.383999	\N	\N	\N
681	PENDING	117	cfac68af-1d56-4459-8b9d-1bfce3d0a9ba	2024-08-06 16:10:58.416113	\N	\N	\N
682	PENDING	117	8c0185f2-27b1-4a84-88ad-6d4f1f89d8d9	2024-08-06 16:11:07.087713	\N	\N	\N
683	PENDING	117	910920cc-b1e1-41e4-b647-331219c8aa31	2024-08-07 08:44:42.275676	\N	\N	\N
684	PENDING	117	be2908d1-adfd-49b2-a66f-c8e75e7d9d1e	2024-08-07 08:48:49.764613	\N	\N	\N
685	PENDING	117	ce8f112b-b37d-4cce-814c-0f6d18c9fc9e	2024-08-08 11:11:37.85446	\N	\N	\N
686	PENDING	117	b1f6f47d-17ae-473b-b123-30e53aa67169	2024-08-08 11:23:57.641402	\N	\N	\N
687	PENDING	117	ebe626c6-8ff0-4516-b076-bb81a7078362	2024-08-08 11:24:12.057061	\N	\N	\N
688	PENDING	117	cea5dbf6-e2db-4792-8bbe-de2a9fa43c34	2024-08-08 11:25:30.765997	\N	\N	\N
689	PENDING	117	6ac6f59b-d3c1-409f-954d-4b37171f2b4f	2024-08-08 11:25:42.685294	\N	\N	\N
690	ACCEPTED	1236	4f9b9c95-84fb-4588-b875-0e8ab9f8728a	2024-08-19 10:21:54.667645	2024-08-19 10:21:55.956291	13	\N
691	ACCEPTED	1238	72c3efa3-c248-4153-90a8-fe26f33f6813	2024-08-19 10:24:57.416103	2024-08-19 10:24:58.040099	13	\N
692	ACCEPTED	1242	59fbda6e-3d4d-48af-b866-7fe89536bb4e	2024-08-19 10:25:13.770397	2024-08-19 10:25:15.248235	13	\N
693	ACCEPTED	1246	cde45722-cde3-4a47-af96-96d6eeba7baa	2024-08-19 10:25:30.589369	2024-08-19 10:25:31.814851	13	\N
694	ACCEPTED	1248	1eb9abb5-c913-4462-99c2-7d5f84749ee9	2024-08-19 10:25:40.639618	2024-08-19 10:25:41.19542	13	\N
695	ACCEPTED	1250	a6ae79f7-1596-42d8-973f-9b247328f93e	2024-08-19 10:25:50.014029	2024-08-19 10:25:50.877484	13	\N
696	DECLINED	1252	a7dc5735-fa91-4fc3-bb3d-9c5b3434d22c	2024-08-19 10:25:59.396561	2024-08-19 10:25:59.967002	13	\N
697	ACCEPTED	1252	621eb69d-885e-4bf2-b221-ded1168f7af9	2024-08-19 10:26:02.178674	2024-08-19 10:26:02.727213	13	\N
698	ACCEPTED	1254	bc1f4188-3d2b-4a0f-97b6-6d001a31c3e1	2024-08-19 10:26:11.502713	2024-08-19 10:26:12.03137	13	\N
699	ACCEPTED	1261	9810bd67-6a26-4aa6-92b7-13a3639df9f5	2024-08-19 10:28:25.890347	2024-08-19 10:28:26.189913	13	\N
700	ACCEPTED	1265	95bd0725-3e42-44b9-b139-361aa715c9a6	2024-08-19 10:28:33.90559	2024-08-19 10:28:34.780937	13	\N
701	ACCEPTED	1269	47ae1002-14fb-42e3-a8e2-1683553639b6	2024-08-19 10:28:43.18066	2024-08-19 10:28:43.904531	13	\N
702	ACCEPTED	1271	988dc2c5-e160-4ea1-959d-b0cf72ade269	2024-08-19 10:28:48.722424	2024-08-19 10:28:49.01999	13	\N
703	ACCEPTED	1273	c50a5fe7-003e-4225-a0de-b358d6ea8021	2024-08-19 10:28:53.899673	2024-08-19 10:28:54.362363	13	\N
704	DECLINED	1275	d170c12d-39fa-42bd-a772-7b75c5273224	2024-08-19 10:28:59.008955	2024-08-19 10:28:59.304898	13	\N
705	ACCEPTED	1275	cbd80a1f-7317-4a6a-94c4-b5f94dd321c0	2024-08-19 10:29:00.442096	2024-08-19 10:29:00.746451	13	\N
706	ACCEPTED	1277	f7d6f5fa-e534-4470-8635-d76c86100d45	2024-08-19 10:29:05.440104	2024-08-19 10:29:05.754359	13	\N
707	ACCEPTED	1282	1f2aa262-ba4a-434c-b937-e047b73d95e8	2024-08-20 09:54:51.550678	2024-08-20 09:54:51.964364	13	\N
708	ACCEPTED	1286	142aa423-fd05-4fa1-b999-e8cb5d152f34	2024-08-20 09:55:02.314867	2024-08-20 09:55:03.49317	13	\N
709	ACCEPTED	1290	610ff360-4750-4795-9a19-13b8c9af28dc	2024-08-20 09:55:15.028421	2024-08-20 09:55:15.919149	13	\N
710	ACCEPTED	1292	b4d06237-0d4b-4b62-a45a-894b060e2af2	2024-08-20 09:55:22.351667	2024-08-20 09:55:22.75238	13	\N
711	ACCEPTED	1294	f2df9277-83b5-48bc-a592-e353c7dd645c	2024-08-20 09:55:29.214807	2024-08-20 09:55:29.80145	13	\N
712	DECLINED	1296	7921c5f2-c76a-4eaa-96a4-95fd4bc089b9	2024-08-20 09:55:36.001073	2024-08-20 09:55:36.40155	13	\N
713	ACCEPTED	1296	507c43ce-3764-43ac-8c58-4078f65b3415	2024-08-20 09:55:37.950525	2024-08-20 09:55:38.349934	13	\N
714	ACCEPTED	1298	df975804-6488-438c-bb03-30080b998d93	2024-08-20 09:55:44.623895	2024-08-20 09:55:45.008221	13	\N
715	ACCEPTED	1303	8f3870a8-b133-422a-a367-a5f0dca2b0bc	2024-08-20 15:09:04.769897	2024-08-20 15:09:05.052392	13	\N
716	ACCEPTED	1307	52bd71dd-3cba-4c47-b275-3051942a83dd	2024-08-20 15:09:11.799299	2024-08-20 15:09:12.632957	13	\N
717	ACCEPTED	1311	c56b5a9a-e5b9-493a-9de0-1762463dd6d8	2024-08-20 15:09:19.742039	2024-08-20 15:09:20.38872	13	\N
718	ACCEPTED	1313	c6818682-f08e-4b04-a689-e13e17c68ffa	2024-08-20 15:09:24.471848	2024-08-20 15:09:24.721449	13	\N
719	ACCEPTED	1315	9d8ecbd1-eca0-4421-9b9b-8601f158c4d8	2024-08-20 15:09:29.022273	2024-08-20 15:09:29.434688	13	\N
720	DECLINED	1317	7b7abf63-e973-4fab-a094-8c4ff7ad1863	2024-08-20 15:09:33.499551	2024-08-20 15:09:33.757481	13	\N
721	ACCEPTED	1317	ee91e226-7eb2-4f14-a067-ff0673b34d56	2024-08-20 15:09:34.662131	2024-08-20 15:09:34.91744	13	\N
722	ACCEPTED	1319	bd6e1fec-2ea0-4ac4-a173-38f06a903989	2024-08-20 15:09:38.980726	2024-08-20 15:09:39.240669	13	\N
723	ACCEPTED	1324	78ac4eb7-d652-495a-9ffe-91c94fd8891f	2024-08-28 13:54:28.71406	2024-08-28 13:54:29.060246	13	\N
724	ACCEPTED	1328	7ba2da9c-647e-446f-847d-23a5f6b6cfe3	2024-08-28 13:54:37.385545	2024-08-28 13:54:38.328461	13	\N
725	ACCEPTED	1332	06965f65-a265-4b06-bf38-2662ea963a85	2024-08-28 13:54:46.900367	2024-08-28 13:54:47.653083	13	\N
726	ACCEPTED	1334	9e3f20a4-0c1a-4967-9db4-d7887b3ccd4d	2024-08-28 13:54:52.662255	2024-08-28 13:54:52.966772	13	\N
727	ACCEPTED	1336	4dbcaae4-5a80-482f-a523-a49ada8bda54	2024-08-28 13:54:57.952216	2024-08-28 13:54:58.460533	13	\N
728	DECLINED	1338	04c4f23b-dda2-414b-ab89-4167d72cabdd	2024-08-28 13:55:03.638126	2024-08-28 13:55:03.96484	13	\N
729	ACCEPTED	1338	5abb05b3-1db1-4dc3-aebd-27b1fce842b7	2024-08-28 13:55:05.079225	2024-08-28 13:55:05.419308	13	\N
730	ACCEPTED	1340	c9db4a5c-ce8d-47bd-8843-13829a2420f0	2024-08-28 13:55:10.325752	2024-08-28 13:55:10.642955	13	\N
731	ACCEPTED	1345	a54c040b-3f27-4820-b05f-51cc2c119bd1	2024-08-28 17:04:24.53958	2024-08-28 17:04:24.895325	13	\N
732	ACCEPTED	1349	667208b8-7662-4cae-b654-00676bf21231	2024-08-28 17:04:33.601892	2024-08-28 17:04:34.568699	13	\N
733	ACCEPTED	1353	463b2f7f-0dee-4602-88b6-85ea35affcc7	2024-08-28 17:04:43.993277	2024-08-28 17:04:44.773339	13	\N
734	ACCEPTED	1355	183154fc-83ed-48bf-8108-33fe364c377e	2024-08-28 17:04:50.13732	2024-08-28 17:04:50.510869	13	\N
735	ACCEPTED	1357	a73be244-7af9-4eaa-b33e-ab1af1061fa7	2024-08-28 17:04:55.878849	2024-08-28 17:04:56.388523	13	\N
736	DECLINED	1359	89a1a986-4679-4f9d-bfa9-30a841342fb3	2024-08-28 17:05:01.568549	2024-08-28 17:05:01.983102	13	\N
737	ACCEPTED	1359	78910403-01b4-4a17-97f8-be42e95a895e	2024-08-28 17:05:03.208274	2024-08-28 17:05:03.569082	13	\N
738	ACCEPTED	1361	d651d0fc-3614-4b02-8923-bde656690aa2	2024-08-28 17:05:08.849009	2024-08-28 17:05:09.21302	13	\N
739	ACCEPTED	1366	aa1f78ef-e147-41ec-abbe-1d3c832dd0de	2024-09-02 14:29:48.665433	2024-09-02 14:29:49.384946	13	\N
740	ACCEPTED	1370	422bed0e-b1a8-4258-b080-ffe836f32b4f	2024-09-02 14:30:00.809775	2024-09-02 14:30:02.524526	13	\N
741	ACCEPTED	1374	2cae90f2-52fe-4180-8369-355072697096	2024-09-02 14:30:13.858254	2024-09-02 14:30:15.06019	13	\N
742	ACCEPTED	1376	4d916edc-32ae-47ac-b66c-9b71976a4d0d	2024-09-02 14:30:21.198309	2024-09-02 14:30:21.652015	13	\N
743	ACCEPTED	1378	c81590cf-7dfc-4c55-b4e2-67bddac0fa79	2024-09-02 14:30:27.649964	2024-09-02 14:30:28.326533	13	\N
744	DECLINED	1380	717c8f75-3be9-4259-8dea-5e24b23e1331	2024-09-02 14:30:33.973929	2024-09-02 14:30:34.385124	13	\N
745	ACCEPTED	1380	3905d2ef-1af4-45a6-8f98-a289b79fdbe1	2024-09-02 14:30:35.684875	2024-09-02 14:30:36.077211	13	\N
746	ACCEPTED	1382	764e56c6-47e9-4d82-aa22-844748297ba4	2024-09-02 14:30:41.897505	2024-09-02 14:30:42.338651	13	\N
747	ACCEPTED	1387	0c31e447-d7ac-41e9-963c-7c28bd7b6d67	2024-09-04 19:34:20.14217	2024-09-04 19:34:20.480639	13	\N
748	ACCEPTED	1391	656cb45c-41c2-4dcd-816e-4efe130f3312	2024-09-04 19:34:27.915512	2024-09-04 19:34:28.850478	13	\N
749	ACCEPTED	1395	af1a7670-a6da-4284-bac1-ce366b6584c8	2024-09-04 19:34:37.032603	2024-09-04 19:34:37.762678	13	\N
750	ACCEPTED	1397	b1ff476a-465c-4f2b-b4a6-48b846fd910d	2024-09-04 19:34:42.542253	2024-09-04 19:34:42.869196	13	\N
751	ACCEPTED	1399	eee7cae7-1444-4c74-b2dd-a569b40d5934	2024-09-04 19:34:47.753033	2024-09-04 19:34:48.276069	13	\N
752	DECLINED	1401	f8183210-2d51-48c2-88d8-c95326a29709	2024-09-04 19:34:52.723543	2024-09-04 19:34:53.045313	13	\N
753	ACCEPTED	1401	abc23daf-5c4d-485b-ace7-e35202906571	2024-09-04 19:34:54.06838	2024-09-04 19:34:54.351079	13	\N
754	ACCEPTED	1403	385199f8-5029-4000-8bd4-1e59bc1b4da4	2024-09-04 19:34:58.692855	2024-09-04 19:34:59.026108	13	\N
755	ACCEPTED	1408	6a2daa64-81d4-4e2a-83cc-869217981ee9	2024-09-04 20:03:58.489976	2024-09-04 20:03:58.812602	13	\N
756	ACCEPTED	1412	09df2725-5ce6-4793-b438-c475e0390ced	2024-09-04 20:04:06.513057	2024-09-04 20:04:07.396099	13	\N
757	ACCEPTED	1416	e7114fd8-fae1-4fec-8976-74c48ebb40b2	2024-09-04 20:04:15.469781	2024-09-04 20:04:16.209585	13	\N
758	ACCEPTED	1418	cb940258-1f09-4741-930b-16639a255303	2024-09-04 20:04:20.811858	2024-09-04 20:04:21.133093	13	\N
759	ACCEPTED	1420	baa7ae52-d9bb-43fe-9416-74701fef61bd	2024-09-04 20:04:25.666775	2024-09-04 20:04:26.170166	13	\N
760	DECLINED	1422	c0d6179a-0e38-426e-9c24-5b12083d1269	2024-09-04 20:04:30.599471	2024-09-04 20:04:30.886494	13	\N
761	ACCEPTED	1422	53a633eb-89fd-44b7-a6a6-aef296bd5108	2024-09-04 20:04:31.831426	2024-09-04 20:04:32.120789	13	\N
762	ACCEPTED	1424	ca4f8298-f246-4a78-8e1e-4bb5871dd1d0	2024-09-04 20:04:36.478163	2024-09-04 20:04:36.77478	13	\N
763	ACCEPTED	1429	4437044c-71ae-447a-823c-57faf9d48bee	2024-09-08 11:46:45.212165	2024-09-08 11:46:45.735097	13	\N
764	ACCEPTED	1433	ebb6fafe-f98e-401c-9e54-ccb0f691be4a	2024-09-08 11:46:56.663166	2024-09-08 11:46:57.866338	13	\N
765	ACCEPTED	1437	14d77be0-cf35-462e-a118-c84729bf9efc	2024-09-08 11:47:09.820589	2024-09-08 11:47:10.778863	13	\N
766	ACCEPTED	1439	96120a5e-0bfa-4a95-9102-4d65cb5f421b	2024-09-08 11:47:17.834083	2024-09-08 11:47:18.272297	13	\N
767	ACCEPTED	1441	aa588ed7-ed3a-430d-9ede-3384e28b87a7	2024-09-08 11:47:24.950209	2024-09-08 11:47:25.597946	13	\N
768	DECLINED	1443	9679b3de-d9ea-459f-b198-05826480186d	2024-09-08 11:47:32.055375	2024-09-08 11:47:32.479044	13	\N
769	ACCEPTED	1443	91ff9109-8f2c-4c1e-a5be-b80d418ac7e4	2024-09-08 11:47:34.065918	2024-09-08 11:47:34.480737	13	\N
770	ACCEPTED	1445	935b91b5-3f52-4052-9d85-ac926b5d54f0	2024-09-08 11:47:40.956715	2024-09-08 11:47:41.412505	13	\N
771	ACCEPTED	1450	0bc2d521-c106-4525-8baf-46a314cbc5ff	2024-09-08 12:03:11.85263	2024-09-08 12:03:12.189938	13	\N
772	ACCEPTED	1454	68625651-c007-4062-b540-3a991d9d594e	2024-09-08 12:03:19.238641	2024-09-08 12:03:20.074105	13	\N
773	ACCEPTED	1458	3d04f918-93aa-48b7-af4e-d63649d11f91	2024-09-08 12:03:27.873232	2024-09-08 12:03:28.566337	13	\N
774	ACCEPTED	1460	e7e39bc2-a2a3-417a-806c-866fc9a8b148	2024-09-08 12:03:32.955806	2024-09-08 12:03:33.256473	13	\N
775	ACCEPTED	1462	2aa7255c-7aa9-47e0-9c34-e95cb6fe82d7	2024-09-08 12:03:37.81946	2024-09-08 12:03:38.353494	13	\N
776	DECLINED	1464	8a17a526-8be8-4b98-a9c6-c6cc2ed31c9c	2024-09-08 12:03:42.92809	2024-09-08 12:03:43.231331	13	\N
777	ACCEPTED	1464	896b29ba-cd3b-4d1a-9b60-ee4ce518abd5	2024-09-08 12:03:44.235915	2024-09-08 12:03:44.580572	13	\N
778	ACCEPTED	1466	8f954f47-9bd2-46d5-b009-f0939bfd2251	2024-09-08 12:03:49.225472	2024-09-08 12:03:49.509739	13	\N
779	ACCEPTED	1471	27414ec1-10b5-4182-a201-d125d4e81806	2024-09-08 12:07:34.80643	2024-09-08 12:07:35.555496	13	\N
780	ACCEPTED	1475	c7e893f3-f5f2-4d01-b849-fd989e3e2976	2024-09-08 12:07:46.182067	2024-09-08 12:07:47.496759	13	\N
781	ACCEPTED	1479	c8741e44-e774-43c4-bcad-4d4f4d35629f	2024-09-08 12:07:57.085974	2024-09-08 12:07:58.076574	13	\N
782	ACCEPTED	1481	4c6a1db9-b2e2-4fc9-8baa-52cfd90be703	2024-09-08 12:08:03.495045	2024-09-08 12:08:03.933854	13	\N
783	ACCEPTED	1483	f2523211-62a4-40e1-a300-007f38ba4300	2024-09-08 12:08:09.049743	2024-09-08 12:08:09.608545	13	\N
784	DECLINED	1485	7017a81f-615f-4c73-8d2b-bc7fc172d0f2	2024-09-08 12:08:14.777063	2024-09-08 12:08:15.188574	13	\N
785	ACCEPTED	1485	3a8a4c92-5a75-4a9b-8d73-a90e1bca1c4d	2024-09-08 12:08:16.258961	2024-09-08 12:08:16.602919	13	\N
786	ACCEPTED	1487	6678a132-39bd-47d1-af6b-f4a3bbc68145	2024-09-08 12:08:21.362842	2024-09-08 12:08:21.692614	13	\N
787	ACCEPTED	1492	3896fc5b-bc6c-4165-9326-10f0a3651390	2024-09-08 12:21:29.554429	2024-09-08 12:21:30.03274	13	\N
788	ACCEPTED	1496	f4a1eb0e-bbb6-4f9c-a38f-425ce6b1ef83	2024-09-08 12:21:41.376855	2024-09-08 12:21:43.164576	13	\N
789	ACCEPTED	1500	faa23b56-271a-4bf1-8e1a-cb9a94f6c4ef	2024-09-08 12:21:55.392461	2024-09-08 12:21:56.47238	13	\N
790	ACCEPTED	1502	8a0a4741-1052-4f01-b949-a1ae5bdb6d2a	2024-09-08 12:22:03.415282	2024-09-08 12:22:03.852585	13	\N
791	ACCEPTED	1504	cfef96fb-6d7b-4788-8d14-f3371e66b651	2024-09-08 12:22:10.72161	2024-09-08 12:22:11.452559	13	\N
792	DECLINED	1506	1ed99cf6-6859-4e2d-a93c-ea981a9a1684	2024-09-08 12:22:18.104364	2024-09-08 12:22:18.537707	13	\N
793	ACCEPTED	1506	8991a689-d7cc-4ca0-ab34-f3d02b4580e5	2024-09-08 12:22:20.236653	2024-09-08 12:22:20.684549	13	\N
794	ACCEPTED	1508	9c6b0cdb-de63-413a-a5b7-42636aeb37da	2024-09-08 12:22:27.290612	2024-09-08 12:22:27.758918	13	\N
795	ACCEPTED	1513	6cb5cfdb-b0ad-4ff1-89b1-c1e472441407	2024-09-15 17:05:06.44486	2024-09-15 17:05:06.820809	13	\N
796	ACCEPTED	1517	9c108dae-c7a2-4e86-adc7-b1c9213e0a68	2024-09-15 17:05:14.114765	2024-09-15 17:05:15.004275	13	\N
797	ACCEPTED	1521	ca8660b5-9639-405e-88fe-654db315d340	2024-09-15 17:05:22.695183	2024-09-15 17:05:23.372588	13	\N
798	ACCEPTED	1523	4776db5c-e3d0-4d9f-922b-04bb2de65b98	2024-09-15 17:05:27.847715	2024-09-15 17:05:28.148226	13	\N
799	ACCEPTED	1525	8d194ea1-0a0b-4010-93d9-06756cce7066	2024-09-15 17:05:32.581288	2024-09-15 17:05:33.018551	13	\N
800	DECLINED	1527	a29af6bd-166b-4a2d-a4c9-ba8912919d53	2024-09-15 17:05:37.205409	2024-09-15 17:05:37.483306	13	\N
801	ACCEPTED	1527	8599942e-5c07-4f0e-8532-b5e0960b3bd5	2024-09-15 17:05:38.438475	2024-09-15 17:05:38.704857	13	\N
802	ACCEPTED	1529	65d73809-24cd-4540-b259-cc5281bd352c	2024-09-15 17:05:42.774823	2024-09-15 17:05:43.065852	13	\N
803	ACCEPTED	107	60e9919b-24b4-4843-abb3-a5107655e644	2024-09-17 10:01:28.861303	2024-09-17 10:04:17.987019	1	\N
804	PENDING	107	3cefe3ea-1f73-44c6-9623-7ea32e13635f	2024-09-17 10:23:19.753857	\N	\N	Кек лол
805	ACCEPTED	1534	f98e1891-8c26-46ba-b6c2-3b7bff3e6d75	2024-09-18 20:09:38.227951	2024-09-18 20:09:38.616547	13	\N
806	ACCEPTED	1538	b215397e-e9f3-45d0-9f61-6e86ca1afe55	2024-09-18 20:09:47.803063	2024-09-18 20:09:48.90295	13	\N
807	ACCEPTED	1542	6b78e0b3-309c-4f18-a192-82f006c1c916	2024-09-18 20:09:58.552558	2024-09-18 20:09:59.415681	13	\N
808	ACCEPTED	1544	c0bfb95c-2c17-4aee-b3ec-dba86b584b09	2024-09-18 20:10:05.559766	2024-09-18 20:10:05.952374	13	\N
809	ACCEPTED	1546	65a0214a-6226-4e63-bfc2-05adff1228dc	2024-09-18 20:10:11.746858	2024-09-18 20:10:12.350291	13	\N
810	DECLINED	1548	13daaaf7-59c4-4b06-a9ba-c52fbb9930c1	2024-09-18 20:10:17.777635	2024-09-18 20:10:18.121705	13	\N
811	ACCEPTED	1548	7f093781-d1f9-4763-8138-335e59c97aec	2024-09-18 20:10:19.408301	2024-09-18 20:10:19.772171	13	\N
812	ACCEPTED	1550	5b5eeb7d-9303-4a40-a3d8-dbf8a44034da	2024-09-18 20:10:25.166245	2024-09-18 20:10:25.542683	13	\N
813	ACCEPTED	1555	93314770-2b5b-4bbb-8bab-9bf823627877	2024-09-18 20:11:08.869092	2024-09-18 20:11:09.173544	13	\N
814	ACCEPTED	1559	81c7cd44-e1c0-45d5-8f0b-8ed476aab7a3	2024-09-18 20:11:16.679365	2024-09-18 20:11:17.558731	13	\N
815	ACCEPTED	1563	5cb80729-6af6-43c5-afac-21d98f5601e8	2024-09-18 20:11:25.464203	2024-09-18 20:11:26.182759	13	\N
816	ACCEPTED	1565	f9d9de6f-8399-4ff6-bbf6-35a717024c95	2024-09-18 20:11:30.763606	2024-09-18 20:11:31.080285	13	\N
817	ACCEPTED	1567	5d3d878a-5688-40c3-9cc8-a52133a5d721	2024-09-18 20:11:35.465735	2024-09-18 20:11:35.988599	13	\N
818	DECLINED	1569	6b9bdc98-75fe-447c-aeba-8f579c3a0f74	2024-09-18 20:11:40.263726	2024-09-18 20:11:40.561747	13	\N
819	ACCEPTED	1569	1f678065-ed7d-45d0-a109-a5956cd63cf2	2024-09-18 20:11:41.54495	2024-09-18 20:11:41.839903	13	\N
820	ACCEPTED	1571	417bf008-3b00-4106-9eef-b841ac68c2e6	2024-09-18 20:11:46.208758	2024-09-18 20:11:46.500069	13	\N
821	ACCEPTED	1574	da292654-7590-4df2-baad-4935eaa7bffb	2024-09-18 20:32:28.187255	2024-09-18 20:32:28.627733	13	\N
822	ACCEPTED	1578	662820cd-94ee-4942-b7b6-1276a6722da6	2024-09-18 20:32:40.30703	2024-09-18 20:32:41.56578	13	\N
823	ACCEPTED	1582	61cd7a87-a512-42f3-ae72-4619ff6b4c46	2024-09-18 20:32:53.565546	2024-09-18 20:32:54.546244	13	\N
824	ACCEPTED	1584	a09c4416-a66f-43da-824b-29145dd5c2c1	2024-09-18 20:33:01.289542	2024-09-18 20:33:01.733389	13	\N
825	ACCEPTED	1586	eefcd913-a69a-4e32-9621-b595dfd057f9	2024-09-18 20:33:08.557823	2024-09-18 20:33:09.231708	13	\N
826	DECLINED	1588	467c7822-f065-4dc9-9801-bb6bdf949329	2024-09-18 20:33:15.881885	2024-09-18 20:33:16.312112	13	\N
827	ACCEPTED	1588	6f9a83e3-1601-4412-9eec-6ba6c56cbdda	2024-09-18 20:33:17.864044	2024-09-18 20:33:18.264557	13	\N
828	ACCEPTED	1590	86f14468-7783-48af-99cb-021700a28ecc	2024-09-18 20:33:24.658366	2024-09-18 20:33:25.103529	13	\N
829	ACCEPTED	1595	45c8f250-2105-45a3-9853-8e6ac4bae592	2024-09-19 17:58:41.695361	2024-09-19 17:58:42.054479	13	\N
830	ACCEPTED	1599	17ba3866-2cef-4d52-908f-979fd66c8e78	2024-09-19 17:58:50.745933	2024-09-19 17:58:57.458681	13	\N
831	ACCEPTED	1603	8d8675c0-b32f-4184-a03b-eef50ad3b392	2024-09-19 17:59:07.125679	2024-09-19 17:59:07.904757	13	\N
832	ACCEPTED	1605	a9dcf841-c67e-4b28-acc2-40d4def2066e	2024-09-19 17:59:13.333347	2024-09-19 17:59:13.69108	13	\N
833	ACCEPTED	1607	794bcfb1-2aa3-4f52-a076-37de7201dc56	2024-09-19 17:59:18.970455	2024-09-19 17:59:19.464599	13	\N
834	DECLINED	1609	74863204-0dbd-48f9-b9e6-10bd300635a2	2024-09-19 17:59:24.553587	2024-09-19 17:59:24.868487	13	\N
835	ACCEPTED	1609	3158b0d5-bdb1-422b-9af2-ea272e18e37d	2024-09-19 17:59:26.0877	2024-09-19 17:59:26.39725	13	\N
836	ACCEPTED	1611	3e9c11a5-70d4-47cc-946c-10e596126463	2024-09-19 17:59:31.569769	2024-09-19 17:59:31.909542	13	\N
837	ACCEPTED	1616	432900b7-8054-457d-ba8b-6a58396ef562	2024-09-19 18:22:09.371272	2024-09-19 18:22:09.78697	13	\N
838	ACCEPTED	1620	f587f9ca-659d-45aa-a36a-42cae8a320b2	2024-09-19 18:22:20.850703	2024-09-19 18:22:22.160473	13	\N
839	ACCEPTED	1624	371d5373-8e2d-450a-b335-fd43bf571223	2024-09-19 18:22:33.713781	2024-09-19 18:22:34.663497	13	\N
840	ACCEPTED	1626	dfcc62b6-d697-487c-af80-b5df341f48dd	2024-09-19 18:22:41.329447	2024-09-19 18:22:41.721016	13	\N
841	ACCEPTED	1628	caa5c20c-f9ef-47b1-b93b-ac98c3789390	2024-09-19 18:22:48.156202	2024-09-19 18:22:48.793092	13	\N
842	DECLINED	1630	d4069f16-08af-4340-933a-e4d69691157a	2024-09-19 18:22:54.988148	2024-09-19 18:22:55.406813	13	\N
843	ACCEPTED	1630	43851199-d6a6-4cdd-961e-77b7fdb640bf	2024-09-19 18:22:56.902819	2024-09-19 18:22:57.302235	13	\N
844	ACCEPTED	1632	b597c856-1bc2-4fbb-890f-8a38f04cbef8	2024-09-19 18:23:04.344676	2024-09-19 18:23:04.803228	13	\N
845	ACCEPTED	1637	d165bb22-726a-4307-b6a5-d693f20944ff	2024-09-19 18:35:23.411841	2024-09-19 18:35:23.838344	13	\N
846	ACCEPTED	1641	4e735125-0ea5-4c71-8f91-dc2094ab4e8f	2024-09-19 18:35:35.171939	2024-09-19 18:35:36.419338	13	\N
847	ACCEPTED	1645	4108fc81-e856-4c6a-a116-00fbb652afc8	2024-09-19 18:35:47.477636	2024-09-19 18:35:48.381734	13	\N
848	ACCEPTED	1647	5bf182c9-2543-48fb-ba6f-4a05d7870e2c	2024-09-19 18:35:54.851092	2024-09-19 18:35:55.236798	13	\N
849	ACCEPTED	1649	9a934b23-e0fc-40b9-93af-ded318489cee	2024-09-19 18:36:01.646982	2024-09-19 18:36:02.283712	13	\N
850	DECLINED	1651	918955f3-e263-4e4e-865a-651ab9b3469c	2024-09-19 18:36:08.486653	2024-09-19 18:36:08.871732	13	\N
851	ACCEPTED	1651	dfe4d50b-aaa2-4e2e-8509-31dac3553210	2024-09-19 18:36:10.329907	2024-09-19 18:36:10.719623	13	\N
852	ACCEPTED	1653	ac084315-d0f6-4a38-97a4-6997abdd8da9	2024-09-19 18:36:16.765023	2024-09-19 18:36:17.151991	13	\N
853	ACCEPTED	1658	930ccaf1-3c29-4741-b6dd-563bf8df3c0b	2024-09-19 18:38:35.351378	2024-09-19 18:38:35.673587	13	\N
854	ACCEPTED	1662	1af9cc4d-0709-4739-b050-551d8e6e7d28	2024-09-19 18:38:43.891629	2024-09-19 18:38:44.742719	13	\N
855	ACCEPTED	1666	b1797ff9-604b-4f1a-be0c-05f18d9042f1	2024-09-19 18:38:52.427483	2024-09-19 18:38:53.117161	13	\N
856	ACCEPTED	1668	a64b2cc8-4c10-47fd-a2d6-93056b3aff6b	2024-09-19 18:38:57.475945	2024-09-19 18:38:57.737002	13	\N
857	ACCEPTED	1670	646a335b-7804-4b81-8992-f383afff8209	2024-09-19 18:39:02.677023	2024-09-19 18:39:03.187405	13	\N
858	DECLINED	1672	22e4dcb3-a432-437c-bb78-507c5cfca4f9	2024-09-19 18:39:07.57396	2024-09-19 18:39:07.853069	13	\N
859	ACCEPTED	1672	76eb8435-9238-4790-b09c-55454daba72d	2024-09-19 18:39:08.794819	2024-09-19 18:39:09.097926	13	\N
860	ACCEPTED	1674	f671b7ac-50ad-484a-8a31-c03f1cf209a6	2024-09-19 18:39:13.468188	2024-09-19 18:39:13.769939	13	\N
861	ACCEPTED	1679	8aec48ed-fda0-49ad-817b-9436a27ecc73	2024-09-20 11:45:18.083213	2024-09-20 11:45:18.399048	13	\N
862	ACCEPTED	1683	3f444ac3-174f-4fc5-91b1-8757e7b35e8e	2024-09-20 11:45:26.302376	2024-09-20 11:45:27.205585	13	\N
863	ACCEPTED	1687	9e7e760f-5021-43aa-b075-eabaa90947a5	2024-09-20 11:45:35.09293	2024-09-20 11:45:35.78151	13	\N
864	ACCEPTED	1689	5c226eb5-5d47-4f12-a2ed-e593d275742c	2024-09-20 11:45:40.383538	2024-09-20 11:45:40.670116	13	\N
865	ACCEPTED	1691	b55404f0-cf3d-4cd1-9b5a-68bfafba9429	2024-09-20 11:45:45.021929	2024-09-20 11:45:45.453386	13	\N
866	DECLINED	1693	58ea23d2-ed46-4156-9c18-89e910bcd88f	2024-09-20 11:45:49.687227	2024-09-20 11:45:49.958425	13	\N
867	ACCEPTED	1693	92f61ff4-dc49-4878-ba4b-5b60eedced1b	2024-09-20 11:45:50.895973	2024-09-20 11:45:51.172215	13	\N
868	ACCEPTED	1695	13b3afa7-4f50-413a-8b79-2f5d5755fa25	2024-09-20 11:45:55.267237	2024-09-20 11:45:55.553678	13	\N
869	ACCEPTED	1700	4e5d5f76-bf41-48cd-9376-0aee4d5c3806	2024-09-22 13:09:38.381936	2024-09-22 13:09:38.716607	13	\N
870	ACCEPTED	1704	1037b959-4421-4d50-b7a9-40775b7ed040	2024-09-22 13:09:46.359548	2024-09-22 13:09:47.378346	13	\N
871	ACCEPTED	1708	2e892ae1-f6a8-4d88-a07c-7e08111868cf	2024-09-22 13:09:54.926869	2024-09-22 13:09:55.731374	13	\N
872	ACCEPTED	1710	2a5312f9-d5cf-416b-a0a7-cdc0f285814a	2024-09-22 13:10:00.109498	2024-09-22 13:10:00.463934	13	\N
873	ACCEPTED	1712	bc08e6a3-176d-4d28-a9a6-9e4fca3de707	2024-09-22 13:10:05.683566	2024-09-22 13:10:06.123056	13	\N
874	DECLINED	1714	2d0104c4-6990-4989-94bd-9fa2cc5cc911	2024-09-22 13:10:10.507645	2024-09-22 13:10:10.784505	13	\N
875	ACCEPTED	1714	3db09375-4620-4596-a76c-bb302fc375f6	2024-09-22 13:10:11.733792	2024-09-22 13:10:12.022918	13	\N
876	ACCEPTED	1716	5d1d029a-7e1b-4538-99a2-c775b13778b8	2024-09-22 13:10:16.200696	2024-09-22 13:10:16.473541	13	\N
877	ACCEPTED	1721	f588d4a9-4192-4756-905e-9e3b6100a24e	2024-10-07 15:34:30.231391	2024-10-07 15:34:30.645773	13	\N
878	ACCEPTED	1725	6a527752-8014-4997-ad79-506cb9f94950	2024-10-07 15:34:38.286678	2024-10-07 15:34:39.123795	13	\N
879	ACCEPTED	1729	d15ec02b-74f1-4f5e-9b19-eb7925b5f720	2024-10-07 15:34:46.520078	2024-10-07 15:34:47.164922	13	\N
880	ACCEPTED	1731	3f6ada2e-bd2c-418f-9107-0d8c0a7b2a77	2024-10-07 15:34:51.365133	2024-10-07 15:34:51.622337	13	\N
881	ACCEPTED	1733	dacd90e1-aa88-494a-b1a2-84ac61ae1ee9	2024-10-07 15:34:55.727025	2024-10-07 15:34:56.150871	13	\N
882	DECLINED	1735	2a088104-50a9-4da3-9658-f085d1649c10	2024-10-07 15:35:00.268608	2024-10-07 15:35:00.570323	13	\N
883	ACCEPTED	1735	51a66606-504e-4c39-9a40-23d8a394a95b	2024-10-07 15:35:01.507825	2024-10-07 15:35:01.871487	13	\N
884	ACCEPTED	1737	35d7c741-73c8-413e-94a7-52c092ac1c6d	2024-10-07 15:35:06.46561	2024-10-07 15:35:06.784776	13	\N
885	ACCEPTED	1744	c9a027af-0e9e-4d99-ae93-7ad21efd73ca	2024-10-11 09:29:41.737911	2024-10-11 09:29:42.166881	13	\N
886	ACCEPTED	1748	880f16ef-1319-4a8d-95ef-41ba92f03bc6	2024-10-11 09:29:52.384099	2024-10-11 09:29:53.572304	13	\N
887	ACCEPTED	1752	4effd9a0-f8ea-4b4e-8a41-8a16f98ca00d	2024-10-11 09:30:05.454564	2024-10-11 09:30:06.432491	13	\N
888	ACCEPTED	1754	45be5e7e-3647-42bf-aa2e-f6271aaa79c7	2024-10-11 09:30:12.972464	2024-10-11 09:30:13.381825	13	\N
889	ACCEPTED	1756	4c35a9a9-fd7a-499c-bc8f-1f021a2eb036	2024-10-11 09:30:19.852679	2024-10-11 09:30:20.466536	13	\N
890	DECLINED	1758	b0ca65f9-b04d-478d-bafe-46f3160b6009	2024-10-11 09:30:26.731616	2024-10-11 09:30:27.134351	13	\N
891	ACCEPTED	1758	37112c38-7725-4932-a03a-7e0f23eebec9	2024-10-11 09:30:28.630535	2024-10-11 09:30:29.065146	13	\N
892	ACCEPTED	1760	6e04c1ee-4c53-4d29-84c7-685e0efb4e6a	2024-10-11 09:30:35.415218	2024-10-11 09:30:35.827267	13	\N
893	ACCEPTED	1765	4bc875fa-97f3-4b1d-a1ea-81ab9c625495	2024-10-14 13:15:51.423874	2024-10-14 13:15:51.86756	13	\N
894	ACCEPTED	1769	dfd91efa-b6a9-44da-8b7a-1a02159e4e3b	2024-10-14 13:16:02.571664	2024-10-14 13:16:03.852283	13	\N
895	ACCEPTED	1773	00ce6d5a-53af-4186-b49e-5c0a2b60d2d0	2024-10-14 13:16:15.506194	2024-10-14 13:16:16.482712	13	\N
896	ACCEPTED	1775	61c70103-ed88-4724-8cd2-b4ab4f49391b	2024-10-14 13:16:23.308053	2024-10-14 13:16:23.722176	13	\N
897	ACCEPTED	1777	fd1ef54b-5569-4b87-9d83-e904fecb932a	2024-10-14 13:16:30.336203	2024-10-14 13:16:30.986246	13	\N
898	DECLINED	1779	0f7f8fdb-7e87-45b3-a8dd-b221c00157af	2024-10-14 13:16:37.51068	2024-10-14 13:16:37.934871	13	\N
899	ACCEPTED	1779	c3a232f6-0331-4361-82ce-406a1bd692af	2024-10-14 13:16:39.515006	2024-10-14 13:16:39.946982	13	\N
900	ACCEPTED	1781	0fd99029-af74-44e0-a66d-1599cf921594	2024-10-14 13:16:46.35963	2024-10-14 13:16:46.777233	13	\N
901	ACCEPTED	1786	d5f3d9bd-87ff-4462-928d-19cbdb85e159	2024-10-14 13:57:05.282645	2024-10-14 13:57:05.584053	13	\N
902	ACCEPTED	1790	6e384144-1796-4604-8494-c16606885848	2024-10-14 13:57:12.687012	2024-10-14 13:57:13.606397	13	\N
903	ACCEPTED	1794	d64f5dce-12f7-486a-933c-89b9db826736	2024-10-14 13:57:21.431368	2024-10-14 13:57:22.180072	13	\N
904	ACCEPTED	1796	430ecb64-0bc3-4246-8384-4805c9c50ad7	2024-10-14 13:57:26.640905	2024-10-14 13:57:26.943151	13	\N
905	ACCEPTED	1798	5021a8df-35ef-455b-80e0-d8451fc3f331	2024-10-14 13:57:31.418757	2024-10-14 13:57:31.872479	13	\N
906	DECLINED	1800	1770a33b-4a45-4be2-b61a-b4162a6e2509	2024-10-14 13:57:36.078847	2024-10-14 13:57:36.358507	13	\N
907	ACCEPTED	1800	bcb8419e-8ba1-4613-9198-276eb5da4249	2024-10-14 13:57:37.298977	2024-10-14 13:57:37.572616	13	\N
908	ACCEPTED	1802	e8b81ced-abe4-4758-846a-6b040b5ef244	2024-10-14 13:57:41.807809	2024-10-14 13:57:42.084358	13	\N
909	ACCEPTED	1807	ee660930-1b71-451d-ab4d-64f5893fb091	2024-10-14 13:59:18.942636	2024-10-14 13:59:19.23567	13	\N
910	ACCEPTED	1811	b5cd56ec-e56b-4690-b6fc-71cc0aa3207b	2024-10-14 13:59:26.365496	2024-10-14 13:59:27.23715	13	\N
911	ACCEPTED	1815	bc16d9a5-9de2-4318-a256-5ed328d0e7d9	2024-10-14 13:59:34.701451	2024-10-14 13:59:35.339707	13	\N
912	ACCEPTED	1817	9c34dd09-d95a-45e7-adf7-ec5276f6f649	2024-10-14 13:59:39.677602	2024-10-14 13:59:39.954939	13	\N
913	ACCEPTED	1819	e06c9aa7-b7b8-46e7-be6d-adab5f9628de	2024-10-14 13:59:44.343468	2024-10-14 13:59:44.757161	13	\N
914	DECLINED	1821	2d8810e7-2820-46e4-ad02-0a70273953c2	2024-10-14 13:59:48.903042	2024-10-14 13:59:49.174564	13	\N
915	ACCEPTED	1821	296833ee-81fb-401b-b048-59d5d40525a0	2024-10-14 13:59:50.089543	2024-10-14 13:59:50.356275	13	\N
916	ACCEPTED	1823	7a0c3661-957f-4e1a-8e22-dda03c139906	2024-10-14 13:59:54.708858	2024-10-14 13:59:54.988335	13	\N
917	ACCEPTED	1826	1ee0de66-4821-456c-ac28-58f3c755c90a	2024-10-17 17:30:03.6287	2024-10-17 17:30:04.378349	13	\N
918	ACCEPTED	1830	04229ac6-bf01-4975-bc8a-337f7e1afae7	2024-10-17 17:30:14.634592	2024-10-17 17:30:15.913457	13	\N
919	ACCEPTED	1834	372aabcc-aa8b-42f4-b996-62fe58ae7cb8	2024-10-17 17:30:24.815719	2024-10-17 17:30:25.696297	13	\N
920	ACCEPTED	1836	817950cb-7769-4be1-819a-e3e2635bdefa	2024-10-17 17:30:30.613203	2024-10-17 17:30:30.950546	13	\N
921	ACCEPTED	1838	419eaaa8-e74f-416d-bd8d-960cd7ec7eb7	2024-10-17 17:30:35.783102	2024-10-17 17:30:36.329736	13	\N
922	DECLINED	1840	f4c384a0-6894-472e-9031-c8f9050d84ec	2024-10-17 17:30:40.86612	2024-10-17 17:30:41.188054	13	\N
923	ACCEPTED	1840	c72ff8f9-1d22-41c8-892a-dd1ab364c545	2024-10-17 17:30:42.163363	2024-10-17 17:30:42.487931	13	\N
924	ACCEPTED	1842	d1668ec7-d209-4b56-8eca-a716edd22270	2024-10-17 17:30:47.035049	2024-10-17 17:30:47.387944	13	\N
925	ACCEPTED	1849	49909814-890d-4370-a5b6-fef09e793937	2024-10-17 17:31:14.257504	2024-10-17 17:31:14.728434	13	\N
926	ACCEPTED	1853	b6851cb2-d8d5-47a8-8dbd-504225092cfa	2024-10-17 17:31:25.815293	2024-10-17 17:31:27.105051	13	\N
927	ACCEPTED	1857	f9219d79-37a4-421b-95cc-a9bc0dda7ae5	2024-10-17 17:31:39.296014	2024-10-17 17:31:40.345614	13	\N
928	ACCEPTED	1859	1666df30-ebec-4e5f-b9c7-a7c32fc7a8ec	2024-10-17 17:31:47.206323	2024-10-17 17:31:47.652533	13	\N
929	ACCEPTED	1861	8e60cea3-cc7d-476f-b15e-3c89fe6b7ae6	2024-10-17 17:31:54.528013	2024-10-17 17:31:55.264505	13	\N
930	DECLINED	1863	c1ad70fe-b14c-49a2-aba7-f5364dfe5c20	2024-10-17 17:32:02.04152	2024-10-17 17:32:02.501208	13	\N
931	ACCEPTED	1863	d0d1b5b6-40eb-489b-9f58-91f5a1d10bf2	2024-10-17 17:32:04.118216	2024-10-17 17:32:04.570709	13	\N
932	ACCEPTED	1865	41b2796e-e5ea-4bdd-928f-cd89c2e545e3	2024-10-17 17:32:11.243298	2024-10-17 17:32:11.676216	13	\N
933	ACCEPTED	1870	a7f751a4-bdeb-450e-9409-23686c671e5b	2024-10-22 12:24:10.043094	2024-10-22 12:24:10.389369	13	\N
934	ACCEPTED	1874	2a868344-b4c5-4d59-a9ed-ba86d94a6279	2024-10-22 12:24:17.843778	2024-10-22 12:24:18.818618	13	\N
935	ACCEPTED	1878	a5c47813-c443-4060-9e50-1a0fe2663396	2024-10-22 12:24:26.775901	2024-10-22 12:24:27.524225	13	\N
936	ACCEPTED	1880	26cc5c4a-64ae-4770-895b-3db7cb53e11c	2024-10-22 12:24:32.103075	2024-10-22 12:24:32.38594	13	\N
937	ACCEPTED	1882	d08bb15e-4178-42a9-bbfd-a244f2b6ce77	2024-10-22 12:24:36.869996	2024-10-22 12:24:37.3384	13	\N
938	DECLINED	1884	40ad408c-1028-4db8-bf35-d6acd3d8b57e	2024-10-22 12:24:41.629329	2024-10-22 12:24:41.914301	13	\N
939	ACCEPTED	1884	e4bb7b44-8497-4247-b70d-87544999b982	2024-10-22 12:24:42.869451	2024-10-22 12:24:43.154286	13	\N
940	ACCEPTED	1886	3db48da1-22f1-4929-bd94-5f728371b450	2024-10-22 12:24:47.395029	2024-10-22 12:24:47.67852	13	\N
941	ACCEPTED	1891	a63a1521-3083-49be-8d41-a03977617db0	2024-10-22 12:43:34.329828	2024-10-22 12:43:34.64176	13	\N
942	ACCEPTED	1895	ef471f92-d28c-4932-9ad7-1058b9c1a916	2024-10-22 12:43:41.748313	2024-10-22 12:43:42.624625	13	\N
943	ACCEPTED	1899	b09c1458-bb56-42a8-a43e-27a852dc7d4f	2024-10-22 12:43:50.250275	2024-10-22 12:43:50.945428	13	\N
944	ACCEPTED	1901	dfdf1a63-a7f3-4de0-8fa4-c199e14c220f	2024-10-22 12:43:55.358254	2024-10-22 12:43:55.660821	13	\N
945	ACCEPTED	1903	2851c466-db09-44a2-bd85-c6aa4f036dea	2024-10-22 12:44:00.175545	2024-10-22 12:44:00.685303	13	\N
946	DECLINED	1905	8814ca78-23e4-4f37-bfa2-34563df5ce93	2024-10-22 12:44:05.298079	2024-10-22 12:44:05.588261	13	\N
947	ACCEPTED	1905	5f721c93-1d99-4071-bafe-eb0ac4bcceb6	2024-10-22 12:44:06.545338	2024-10-22 12:44:06.843865	13	\N
948	ACCEPTED	1907	024cd211-e8e8-4bcd-860a-351c7533fccf	2024-10-22 12:44:11.157985	2024-10-22 12:44:11.462117	13	\N
949	ACCEPTED	1912	05b909b0-b2be-4e1c-b984-cf3e66803ecf	2024-10-22 13:10:25.8246	2024-10-22 13:10:26.145075	13	\N
950	ACCEPTED	1916	0954e98d-3a26-4d55-b294-f274142fd1e0	2024-10-22 13:10:33.340696	2024-10-22 13:10:34.165344	13	\N
951	ACCEPTED	1920	2137ddc2-8480-419a-9afc-874db8185de3	2024-10-22 13:10:42.017786	2024-10-22 13:10:42.998177	13	\N
952	ACCEPTED	1922	f2caafb2-bebf-4b3c-97e8-3f183afc4771	2024-10-22 13:10:47.556877	2024-10-22 13:10:47.839127	13	\N
953	ACCEPTED	1924	9d67b6db-a379-4be2-aea0-3b1ceb0166b7	2024-10-22 13:10:52.53937	2024-10-22 13:10:53.061802	13	\N
954	DECLINED	1926	99683e31-6de5-4001-9fbf-d81781cb6da8	2024-10-22 13:10:57.64941	2024-10-22 13:10:57.929743	13	\N
955	ACCEPTED	1926	ba18fcfb-14e5-4e13-a021-3225eee05cc2	2024-10-22 13:10:58.869353	2024-10-22 13:10:59.170142	13	\N
956	ACCEPTED	1928	c6ce3756-fe1e-4433-8a55-ec48a8e28387	2024-10-22 13:11:03.831404	2024-10-22 13:11:04.127633	13	\N
957	ACCEPTED	1933	0bcdeb39-e3e1-46d1-915b-b2f415ab52a0	2024-10-22 13:16:01.597885	2024-10-22 13:16:02.084986	13	\N
958	ACCEPTED	1937	15f266b2-03f8-4130-b92e-19f8e71e01bc	2024-10-22 13:16:12.810078	2024-10-22 13:16:13.986118	13	\N
959	ACCEPTED	1941	29aee5ef-b0ec-43a9-aa49-0e24f057a51a	2024-10-22 13:16:25.66347	2024-10-22 13:16:26.631498	13	\N
960	ACCEPTED	1943	4b0e4032-7344-48af-8a62-ac52880fde49	2024-10-22 13:16:33.239389	2024-10-22 13:16:33.656438	13	\N
961	ACCEPTED	1945	f78ba357-0ceb-4187-9f29-5589418deda9	2024-10-22 13:16:40.161798	2024-10-22 13:16:40.798576	13	\N
962	DECLINED	1947	aba48910-68a6-4def-8a39-2f08691ba92f	2024-10-22 13:16:47.175023	2024-10-22 13:16:47.623542	13	\N
963	ACCEPTED	1947	fc8b2452-fa53-4c5b-970b-3a50b6085678	2024-10-22 13:16:49.207296	2024-10-22 13:16:49.614424	13	\N
964	ACCEPTED	1949	9cde0b53-60b5-49dd-b368-1af27d37c78d	2024-10-22 13:16:55.984679	2024-10-22 13:16:56.420627	13	\N
965	ACCEPTED	1954	1b2da22c-efaa-4d52-aa88-a420d3b117d5	2024-10-22 13:18:21.502361	2024-10-22 13:18:21.834434	13	\N
966	ACCEPTED	1958	b8de20bb-9920-4123-9abe-068fe5c40321	2024-10-22 13:18:29.944245	2024-10-22 13:18:30.912476	13	\N
967	ACCEPTED	1962	990a9b36-3576-4a14-a774-13020c0cbc52	2024-10-22 13:18:39.517776	2024-10-22 13:18:40.275456	13	\N
968	ACCEPTED	1964	f08f22ff-3cb5-4bda-974e-f718fa6a27b5	2024-10-22 13:18:45.266191	2024-10-22 13:18:45.579417	13	\N
969	ACCEPTED	1966	a9ca6128-e9e9-4dca-ae4a-145ea3ac2c22	2024-10-22 13:18:50.442432	2024-10-22 13:18:50.929182	13	\N
970	DECLINED	1968	40388b1c-a249-4607-9cda-8e1176318ff1	2024-10-22 13:18:55.632104	2024-10-22 13:18:55.941989	13	\N
971	ACCEPTED	1968	ffd59c04-6405-43f9-8da9-2aa778dd488f	2024-10-22 13:18:57.037362	2024-10-22 13:18:57.359833	13	\N
972	ACCEPTED	1970	85266491-d497-4b1e-b577-bae122b9b7b2	2024-10-22 13:19:02.184677	2024-10-22 13:19:02.517155	13	\N
973	ACCEPTED	1975	586250ab-c196-448c-9da5-ac72072d0c5b	2024-10-22 13:22:43.956513	2024-10-22 13:22:44.399549	13	\N
974	ACCEPTED	1979	9c1dbba5-dd98-462a-94ee-0bcaa842a31d	2024-10-22 13:22:54.894517	2024-10-22 13:22:56.102	13	\N
975	ACCEPTED	1983	4a990c3d-113d-4f19-b641-ba4d921096a3	2024-10-22 13:23:07.736068	2024-10-22 13:23:08.696681	13	\N
976	ACCEPTED	1985	5e4d72d2-e7e0-47f5-a484-44b302f292a3	2024-10-22 13:23:15.501926	2024-10-22 13:23:15.921446	13	\N
977	ACCEPTED	1987	0a6e63a1-9724-4eac-aba1-02c6bc247649	2024-10-22 13:23:22.539996	2024-10-22 13:23:23.184981	13	\N
978	DECLINED	1989	9acecfd8-de3c-4ed2-af3e-68ee5f7550f0	2024-10-22 13:23:29.526123	2024-10-22 13:23:29.94075	13	\N
979	ACCEPTED	1989	f21ab645-ee7f-459e-b354-4f2e4ab049b8	2024-10-22 13:23:31.503511	2024-10-22 13:23:31.931575	13	\N
980	ACCEPTED	1991	a6de444e-4f1a-4e7c-b480-926f60ec4020	2024-10-22 13:23:38.316583	2024-10-22 13:23:38.743081	13	\N
981	ACCEPTED	1996	2e2d2062-a3ae-4172-bcc0-0c75db7e0177	2024-10-22 18:35:03.73122	2024-10-22 18:35:04.098173	13	\N
982	ACCEPTED	2000	9a7f76bd-3a14-4dbc-906f-8e2d48ecdb61	2024-10-22 18:35:11.741749	2024-10-22 18:35:12.675038	13	\N
983	ACCEPTED	2004	0f50dc74-24e8-4148-8dd0-5a1bd619a212	2024-10-22 18:35:20.500328	2024-10-22 18:35:21.226482	13	\N
984	ACCEPTED	2006	ef752725-2595-4acb-8062-80ec5403ff68	2024-10-22 18:35:25.687669	2024-10-22 18:35:25.989875	13	\N
985	ACCEPTED	2008	341d0bd7-2c03-4aa0-8eb0-632af3c04144	2024-10-22 18:35:30.486064	2024-10-22 18:35:30.966438	13	\N
986	DECLINED	2010	2b70b55a-c8ed-4a33-81d3-c8889afae876	2024-10-22 18:35:35.330296	2024-10-22 18:35:35.631565	13	\N
987	ACCEPTED	2010	70b4b57d-664d-4850-b871-2c185c661b52	2024-10-22 18:35:36.599445	2024-10-22 18:35:36.876809	13	\N
988	ACCEPTED	2012	c974a518-425a-4c6b-9e1d-cd6998c79da9	2024-10-22 18:35:41.138203	2024-10-22 18:35:41.44331	13	\N
989	ACCEPTED	2017	44e7562e-a180-423c-888d-94f5bbcecabe	2024-10-22 18:37:00.166465	2024-10-22 18:37:00.666746	13	\N
990	ACCEPTED	2021	dc84bab1-fc10-4545-887b-61303289bf51	2024-10-22 18:37:11.720401	2024-10-22 18:37:12.956602	13	\N
991	ACCEPTED	2025	45a74b6d-c967-4c84-83f8-ac8a791a4d12	2024-10-22 18:37:24.840391	2024-10-22 18:37:25.808309	13	\N
992	ACCEPTED	2027	1c6d2fb5-22f3-46c9-ae04-9e42dcc6d609	2024-10-22 18:37:32.735703	2024-10-22 18:37:33.169781	13	\N
993	ACCEPTED	2029	cc1f3c7f-f8bd-4689-b620-e384bb2d62b4	2024-10-22 18:37:39.746774	2024-10-22 18:37:40.422323	13	\N
994	DECLINED	2031	31341ce1-8c15-4c3b-ae7c-ddf309c6a29a	2024-10-22 18:37:46.789935	2024-10-22 18:37:47.209291	13	\N
995	ACCEPTED	2031	3dd884e6-6355-4854-8281-7131e5fa0bc8	2024-10-22 18:37:48.767107	2024-10-22 18:37:49.176361	13	\N
996	ACCEPTED	2033	6744ed98-1666-46ac-855a-fc1614e607d2	2024-10-22 18:37:55.559068	2024-10-22 18:37:55.996758	13	\N
997	ACCEPTED	2038	8275865c-1078-4db7-a9c7-1c6018e22af9	2024-10-22 18:38:41.68896	2024-10-22 18:38:41.980614	13	\N
998	ACCEPTED	2042	a93f6b15-ff73-4d09-a643-1ef6129688fd	2024-10-22 18:38:49.305852	2024-10-22 18:38:50.197378	13	\N
999	ACCEPTED	2046	b896bf49-69f0-4cf6-92ec-5b8b29e9849d	2024-10-22 18:38:57.82048	2024-10-22 18:38:58.504805	13	\N
1000	ACCEPTED	2048	f5d9f287-c12a-4a34-9e99-c0e499e606a1	2024-10-22 18:39:03.294417	2024-10-22 18:39:03.607609	13	\N
1001	ACCEPTED	2050	fbc3fc86-d555-425a-bd74-49841ccd0f14	2024-10-22 18:39:08.04647	2024-10-22 18:39:08.486693	13	\N
1002	DECLINED	2052	8d02998f-3ef2-4967-a724-9ffc99d3836c	2024-10-22 18:39:12.665703	2024-10-22 18:39:12.937355	13	\N
1003	ACCEPTED	2052	897f5b81-541b-43f1-80ce-029ec2bb5a38	2024-10-22 18:39:13.868543	2024-10-22 18:39:14.15298	13	\N
1004	ACCEPTED	2054	1bc7a533-97ad-46a1-bfc7-be986bc07b56	2024-10-22 18:39:18.325584	2024-10-22 18:39:18.601361	13	\N
1005	ACCEPTED	2059	21a6a101-5dad-45f2-9c4a-a82ecd86065f	2024-10-27 12:06:30.288431	2024-10-27 12:06:30.810821	13	\N
1006	ACCEPTED	2063	a602689b-b61d-44e1-b52c-4fc433e104f4	2024-10-27 12:06:41.29131	2024-10-27 12:06:42.43565	13	\N
1007	ACCEPTED	2067	5a29ac7c-e23f-419c-b0dc-6577b1fa6786	2024-10-27 12:06:53.7911	2024-10-27 12:06:54.707453	13	\N
1008	ACCEPTED	2069	243fc06b-27cc-48b9-927d-10a5e241fe50	2024-10-27 12:07:01.231396	2024-10-27 12:07:01.648731	13	\N
1009	ACCEPTED	2071	22fc1f70-2df5-4dbe-89b7-974c571f9fa2	2024-10-27 12:07:08.143591	2024-10-27 12:07:08.759377	13	\N
1010	DECLINED	2073	497e7606-8d1a-491f-9899-51a0e30e4235	2024-10-27 12:07:15.055444	2024-10-27 12:07:15.480611	13	\N
1011	ACCEPTED	2073	49835153-47b3-4ca2-bd04-b5cc1e71dd7f	2024-10-27 12:07:17.005189	2024-10-27 12:07:17.435928	13	\N
1012	ACCEPTED	2075	dcc3e45e-a0bc-4475-bc11-1ff2f216e6f9	2024-10-27 12:07:23.919238	2024-10-27 12:07:24.336926	13	\N
1013	ACCEPTED	2080	415c00f2-e327-46c6-be7a-dee9258a20c7	2024-10-27 12:21:42.819217	2024-10-27 12:21:43.151574	13	\N
1014	ACCEPTED	2084	c62911c3-8f6c-43d0-b8f3-c415e7dc7eb9	2024-10-27 12:21:50.976713	2024-10-27 12:21:51.880649	13	\N
1015	ACCEPTED	2088	5bcb98d9-5c22-4906-b597-e6bec262a78b	2024-10-27 12:22:00.290002	2024-10-27 12:22:01.055271	13	\N
1016	ACCEPTED	2090	c7337717-3ab2-485d-ba3b-7fe5ddd319a4	2024-10-27 12:22:05.988723	2024-10-27 12:22:06.296248	13	\N
1017	ACCEPTED	2092	f42fbb6b-de46-4abc-93cb-4d89c3853ae3	2024-10-27 12:22:11.078379	2024-10-27 12:22:11.561673	13	\N
1018	DECLINED	2094	154fb4f0-7a94-446a-9b15-48ce4d04e867	2024-10-27 12:22:16.238019	2024-10-27 12:22:16.551084	13	\N
1019	ACCEPTED	2094	f9470610-bb83-46e7-94ec-284b8131c293	2024-10-27 12:22:17.634241	2024-10-27 12:22:17.941053	13	\N
1020	ACCEPTED	2096	b5bfc27e-05db-4aa5-a5d4-331d329d4170	2024-10-27 12:22:22.559152	2024-10-27 12:22:22.867218	13	\N
1021	ACCEPTED	2111	affa3775-90cd-44be-bb83-36afcf88b8a6	2024-10-29 12:09:47.488497	2024-10-29 12:09:47.925844	13	\N
1022	ACCEPTED	2115	a78208e5-ed47-486d-805b-5afb5c864bba	2024-10-29 12:09:58.470402	2024-10-29 12:09:59.698661	13	\N
1023	ACCEPTED	2119	b96450ff-638d-47e1-b9fb-165ba7d1278e	2024-10-29 12:10:12.162859	2024-10-29 12:10:13.126555	13	\N
1024	ACCEPTED	2121	95bf1c0c-acd9-45ac-a6da-4a65b5b717e6	2024-10-29 12:10:19.786915	2024-10-29 12:10:20.189494	13	\N
1025	ACCEPTED	2123	a5a40100-ee41-46f3-93ca-1bbbba167964	2024-10-29 12:10:26.834416	2024-10-29 12:10:27.513756	13	\N
1026	DECLINED	2125	7c3b1acf-9d4e-4412-b3ed-49df446fb79a	2024-10-29 12:10:33.912012	2024-10-29 12:10:34.327163	13	\N
1027	ACCEPTED	2125	f5749303-2f5a-4ece-b63d-a65fa6bb778c	2024-10-29 12:10:35.887029	2024-10-29 12:10:36.301239	13	\N
1028	ACCEPTED	2127	39e85b5b-b8e5-49ef-9176-3991db907057	2024-10-29 12:10:42.709614	2024-10-29 12:10:43.111371	13	\N
1029	ACCEPTED	2132	1d1ac648-fbab-4efc-b65b-fe761fda7336	2024-10-30 18:22:19.826103	2024-10-30 18:22:20.117329	13	\N
1030	ACCEPTED	2136	5aba6111-cb1a-4b20-8378-9444c7a17503	2024-10-30 18:22:27.220269	2024-10-30 18:22:28.027936	13	\N
1031	ACCEPTED	2140	2048a1b3-58ba-4cd5-b5a3-c126289b183f	2024-10-30 18:22:35.58962	2024-10-30 18:22:36.263146	13	\N
1032	ACCEPTED	2142	5c4bacb5-e6a4-4360-82b7-aad7fc57ca26	2024-10-30 18:22:40.582334	2024-10-30 18:22:40.85874	13	\N
1033	ACCEPTED	2144	dfa3c549-b808-4e86-be24-4e44ec436bc7	2024-10-30 18:22:45.123535	2024-10-30 18:22:45.557182	13	\N
1034	DECLINED	2146	7fd211b7-08e5-4ebc-a1c3-da42a860494c	2024-10-30 18:22:49.593231	2024-10-30 18:22:49.862112	13	\N
1035	ACCEPTED	2146	ad41fff9-70d2-4dcf-a438-54a9c657fd93	2024-10-30 18:22:50.777117	2024-10-30 18:22:51.039474	13	\N
1036	ACCEPTED	2148	e1722ec3-3e9f-4747-95de-0053ddb93a33	2024-10-30 18:22:55.164921	2024-10-30 18:22:55.45128	13	\N
1037	PENDING	122	f63da397-4921-43f1-8051-9cee05dbd520	2024-11-07 11:57:37.890699	\N	\N	\N
\.


--
-- Data for Name: t_order_item; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_order_item (id, item_id, item_count, order_id) FROM stdin;
1	29	3	1
2	29	3	2
3	29	3	3
4	25	3	4
5	33	2	5
6	26	2	6
7	18	3	6
8	1	1	6
9	33	4	6
10	32	1	6
11	34	2	6
13	2	2	8
12	21	10	7
14	1	2	9
15	1	1	10
16	29	1	10
17	21	4	10
18	31	1	11
19	1	1	12
20	20	1	13
21	29	1	14
22	30	1	15
23	31	1	15
24	29	1	15
25	35	1	15
27	38	1	17
28	29	3	17
29	31	3	18
30	35	2	19
32	21	1	19
33	38	9	19
31	29	0	19
34	36	3	20
35	25	4	21
36	29	3	22
37	38	5	23
38	28	6	24
39	29	3	25
40	2	4	26
41	20	5	26
42	29	2	27
26	25	0	16
43	29	3	28
44	29	1	29
45	21	1	30
46	29	1	30
47	29	3	31
48	32	1	32
49	31	1	33
50	14	1	34
51	21	1	35
52	29	1	36
53	31	1	37
54	29	1	38
55	31	1	39
56	29	2	40
57	29	1	41
58	31	4	42
59	29	1	43
60	2	3	44
61	1	1	45
62	20	2	46
63	37	1	47
64	1	0	47
65	1	1	48
66	29	3	49
67	29	2	50
68	30	1	51
69	29	1	52
70	21	1	52
71	32	1	52
72	1	4	53
73	1	0	54
74	29	0	55
75	29	1	56
76	1	2	57
77	1	0	58
78	20	1	59
79	1	3	59
80	29	1	59
81	29	1	60
82	29	0	61
83	21	1	62
84	31	1	62
85	25	1	63
86	29	1	64
87	29	1	65
88	29	1	66
89	29	1	67
90	29	1	68
91	29	2	69
92	29	1	70
93	29	1	71
94	29	1	72
95	21	1	73
96	29	2	74
97	29	3	75
98	1	20	76
99	31	1	77
100	35	1	78
101	29	1	79
102	1	1	80
103	32	1	81
104	35	1	82
105	29	1	83
106	29	1	84
107	1	1	84
108	1	1	85
109	29	1	85
110	35	1	86
111	1	1	87
112	35	1	87
113	1	1	88
114	29	1	88
115	35	1	89
116	1	1	90
117	29	1	90
118	35	1	90
119	35	1	91
120	36	1	91
121	29	1	92
122	1	1	92
123	29	0	93
124	17	2	94
125	29	3	95
126	21	2	96
127	29	1	97
128	21	2	98
129	21	3	99
130	21	3	100
131	29	4	101
132	30	6	102
133	21	1	103
134	28	1	104
135	1	1	105
136	34	1	106
137	1	1	107
138	29	1	107
139	35	1	107
140	17	1	108
141	31	2	109
142	1	1	110
143	1	1	111
144	17	1	111
145	29	1	112
146	35	1	112
147	30	2	119
148	30	2	120
149	396	1	124
150	390	1	124
151	388	3	124
152	398	1	124
161	388	3	127
162	390	3	127
163	392	3	127
164	398	1	127
165	404	1	127
166	387	1	128
167	388	1	129
168	390	1	130
169	390	1	131
170	388	5	131
171	387	1	132
172	387	2	133
173	388	1	134
174	429	1	135
175	430	1	135
176	428	1	135
177	392	1	135
178	394	1	135
179	429	2	136
180	387	1	136
181	388	1	136
182	394	1	136
183	387	1	137
184	388	1	137
185	389	1	137
186	390	1	137
187	391	1	137
188	388	1	138
189	387	1	138
190	387	1	139
191	387	1	140
192	387	1	141
193	387	1	142
195	387	1	144
200	391	1	146
201	394	1	146
202	398	1	146
203	399	1	146
204	418	1	146
205	428	1	146
206	419	1	147
207	420	1	147
208	409	1	147
209	412	1	147
210	429	1	147
211	430	1	147
212	388	1	148
221	431	1	151
222	433	1	151
223	408	2	151
224	397	1	151
225	35	2	153
226	14	1	155
227	1	1	155
228	1	1	156
229	3	2	156
230	35	2	157
231	18	1	157
232	35	2	158
233	18	1	158
234	1	1	159
235	35	2	160
236	35	1	161
237	122	2	161
238	389	1	162
239	388	1	163
240	390	1	164
241	388	1	165
242	387	1	165
243	390	1	165
244	394	1	165
245	439	1	165
246	440	1	165
247	442	1	165
248	388	1	166
249	398	2	167
250	403	1	167
251	4	1	168
252	4	1	169
253	4	1	170
254	4	1	171
255	4	1	172
256	4	1	173
257	4	1	174
258	4	1	175
259	4	1	176
260	4	1	177
261	4	1	178
262	4	1	179
263	4	1	180
264	4	1	181
265	4	1	182
266	4	1	183
267	4	1	184
268	4	1	185
269	4	1	186
270	4	1	187
271	4	1	188
272	4	1	189
273	4	1	190
274	4	1	191
275	390	4	192
276	445	1	193
277	409	1	193
278	388	3	194
279	388	1	195
280	4	1	196
281	4	1	197
282	4	1	198
283	7	1	198
284	4	1	199
285	4	3	200
286	7	4	200
287	4	3	201
288	7	4	201
289	4	1	202
290	4	3	203
291	7	4	203
292	4	1	204
293	4	3	205
294	7	4	205
295	4	1	206
296	4	3	207
297	7	4	207
298	4	1	208
299	4	3	209
300	7	4	209
301	4	3	210
302	7	4	210
303	7	4	211
304	4	3	212
305	7	4	212
306	7	4	213
307	4	3	214
308	7	4	214
309	7	4	215
310	4	3	216
311	7	4	216
312	7	4	217
313	4	3	218
314	7	4	218
315	7	4	219
316	4	3	220
317	7	4	220
318	7	4	221
319	4	2	222
320	4	2	223
321	4	3	224
322	7	4	224
323	4	3	225
324	7	4	225
325	4	1	226
326	4	2	227
327	4	3	228
328	7	4	228
329	7	4	229
330	392	1	230
331	4	3	231
332	7	4	231
333	4	3	232
334	7	4	232
335	4	3	233
336	7	4	233
337	4	3	234
338	7	4	234
339	4	3	235
340	7	4	235
341	4	1	236
342	4	2	237
343	4	3	238
344	7	4	238
345	4	3	239
346	7	4	239
347	7	4	240
348	4	3	241
349	7	4	241
350	4	3	242
351	7	4	242
352	4	3	243
353	7	4	243
354	4	1	244
355	4	1	245
356	4	3	246
357	7	4	246
358	4	3	247
359	7	4	247
360	4	1	248
361	4	1	249
362	4	1	250
363	4	1	251
364	4	3	252
365	7	4	252
366	4	3	253
367	7	4	253
368	4	1	254
369	4	2	255
370	4	3	256
371	7	4	256
372	4	3	257
373	7	4	257
374	7	4	258
375	4	3	259
376	7	4	259
377	4	3	260
378	7	4	260
379	4	3	261
380	7	4	261
381	4	1	262
382	4	2	263
383	4	3	264
384	7	4	264
385	4	3	265
386	7	4	265
387	7	4	266
388	4	3	267
389	7	4	267
390	4	3	268
391	7	4	268
392	4	3	269
393	7	4	269
394	4	1	270
395	4	2	271
396	4	3	272
397	7	4	272
398	4	3	273
399	7	4	273
400	7	4	274
401	4	3	275
402	7	4	275
403	4	3	276
404	7	4	276
405	4	3	277
406	7	4	277
407	4	1	278
408	4	2	279
409	4	3	280
410	7	4	280
411	4	3	281
412	7	4	281
413	7	4	282
414	4	3	283
415	7	4	283
416	4	3	284
417	7	4	284
418	4	3	285
419	7	4	285
420	4	1	286
421	4	2	287
422	4	3	288
423	7	4	288
424	4	3	289
425	7	4	289
426	7	4	290
427	4	3	291
428	7	4	291
429	4	3	292
430	7	4	292
431	4	3	293
432	7	4	293
433	4	1	294
434	4	2	295
435	4	3	296
436	7	4	296
437	4	3	297
438	7	4	297
439	7	4	298
440	4	3	299
441	7	4	299
442	4	3	300
443	7	4	300
444	4	3	301
445	7	4	301
446	4	1	302
447	4	2	303
448	4	3	304
449	7	4	304
450	4	3	305
451	7	4	305
452	7	4	306
453	4	3	307
454	7	4	307
455	4	3	308
456	7	4	308
457	4	3	309
458	7	4	309
459	4	1	310
460	4	2	311
461	4	3	312
462	7	4	312
463	4	3	313
464	7	4	313
465	7	4	314
466	4	3	315
467	7	4	315
468	4	3	316
469	7	4	316
470	4	3	317
471	7	4	317
472	4	1	318
473	4	2	319
474	4	3	320
475	7	4	320
476	4	3	321
477	7	4	321
478	7	4	322
479	4	3	323
480	7	4	323
481	4	3	324
482	7	4	324
483	4	3	325
484	7	4	325
485	4	1	326
486	4	2	327
487	4	3	328
488	7	4	328
489	4	3	329
490	7	4	329
491	7	4	330
492	4	3	331
493	7	4	331
494	4	3	332
495	7	4	332
496	4	3	333
497	7	4	333
498	4	2	334
499	4	3	335
500	7	4	335
501	4	3	336
502	7	4	336
503	7	4	337
504	4	3	338
505	7	4	338
506	4	1	339
507	4	3	340
508	7	4	340
509	4	3	341
510	7	4	341
511	4	1	342
512	4	2	343
513	4	3	344
514	7	4	344
515	4	3	345
516	7	4	345
517	7	4	346
518	4	3	347
519	7	4	347
520	4	1	348
521	4	1	349
522	4	1	350
523	4	1	351
524	4	3	352
525	7	4	352
526	4	3	353
527	7	4	353
528	4	1	354
529	4	2	355
530	4	3	356
531	7	4	356
532	4	3	357
533	7	4	357
534	4	3	358
535	7	4	358
536	4	3	359
537	7	4	359
538	4	3	360
539	7	4	360
540	4	1	361
541	4	2	362
542	4	3	363
543	7	4	363
544	4	3	364
545	7	4	364
546	7	4	365
547	4	3	366
548	7	4	366
549	4	3	367
550	7	4	367
551	4	3	368
552	7	4	368
553	4	1	369
554	4	2	370
555	4	3	371
556	7	4	371
557	4	3	372
558	7	4	372
559	7	4	373
560	4	3	374
561	7	4	374
562	4	3	375
563	7	4	375
564	4	3	376
565	7	4	376
566	4	1	377
567	4	2	378
568	4	3	379
569	7	4	379
570	4	3	380
571	7	4	380
572	7	4	381
573	4	3	382
574	7	4	382
575	4	3	383
576	7	4	383
577	4	3	384
578	7	4	384
579	4	1	385
580	4	2	386
581	4	3	387
582	7	4	387
583	4	3	388
584	7	4	388
585	7	4	389
586	4	3	390
587	7	4	390
588	4	3	391
589	7	4	391
590	4	3	392
591	7	4	392
592	4	3	393
593	7	4	393
594	4	1	394
595	4	2	395
596	4	3	396
597	7	4	396
598	4	3	397
599	7	4	397
600	7	4	398
601	4	3	399
602	7	4	399
603	4	3	400
604	7	4	400
605	4	3	401
606	7	4	401
607	4	3	402
608	7	4	402
609	4	3	403
610	7	4	403
611	4	1	404
612	4	2	405
613	4	3	406
614	7	4	406
615	4	3	407
616	7	4	407
617	7	4	408
618	4	3	409
619	7	4	409
620	4	3	410
621	7	4	410
622	4	3	411
623	7	4	411
624	4	1	412
625	4	2	413
626	4	3	414
627	7	4	414
628	4	3	415
629	7	4	415
630	7	4	416
631	4	3	417
632	7	4	417
633	4	3	418
634	7	4	418
635	4	3	419
636	7	4	419
637	4	1	420
638	4	2	421
639	4	3	422
640	7	4	422
641	4	3	423
642	7	4	423
643	7	4	424
644	4	3	425
645	7	4	425
646	4	3	426
647	7	4	426
648	4	3	427
649	7	4	427
650	4	1	428
651	4	2	429
652	4	3	430
653	7	4	430
654	4	3	431
655	7	4	431
656	7	4	432
657	4	3	433
658	7	4	433
659	4	3	434
660	7	4	434
661	4	3	435
662	7	4	435
663	4	1	436
664	4	2	437
665	4	3	438
666	7	4	438
667	4	3	439
668	7	4	439
669	7	4	440
670	4	3	441
671	7	4	441
672	4	3	442
673	7	4	442
674	4	3	443
675	7	4	443
676	4	1	444
677	4	2	445
678	4	3	446
679	7	4	446
680	4	3	447
681	7	4	447
682	7	4	448
683	4	3	449
684	7	4	449
685	4	3	450
686	7	4	450
687	4	3	451
688	7	4	451
689	4	1	452
690	4	2	453
691	4	3	454
692	7	4	454
693	4	3	455
694	7	4	455
695	7	4	456
696	4	3	457
697	7	4	457
698	4	3	458
699	7	4	458
700	4	3	459
701	7	4	459
702	4	1	460
703	4	2	461
704	4	3	462
705	7	4	462
706	4	3	463
707	7	4	463
708	7	4	464
709	4	3	465
710	7	4	465
711	4	3	466
712	7	4	466
713	4	3	467
714	7	4	467
715	4	1	468
716	4	2	469
717	4	3	470
718	7	4	470
719	4	3	471
720	7	4	471
721	7	4	472
722	4	3	473
723	7	4	473
724	4	3	474
725	7	4	474
726	4	3	475
727	7	4	475
728	4	1	476
729	4	2	477
730	4	3	478
731	7	4	478
732	4	3	479
733	7	4	479
734	7	4	480
735	4	3	481
736	7	4	481
737	4	3	482
738	7	4	482
739	4	3	483
740	7	4	483
741	4	1	484
742	4	2	485
743	4	3	486
744	7	4	486
745	4	3	487
746	7	4	487
747	7	4	488
748	4	3	489
749	7	4	489
750	4	3	490
751	7	4	490
752	4	3	491
753	7	4	491
754	4	1	492
755	4	2	493
756	4	3	494
757	7	4	494
758	4	3	495
759	7	4	495
760	7	4	496
761	4	3	497
762	7	4	497
763	4	3	498
764	7	4	498
765	4	3	499
766	7	4	499
767	4	1	500
768	4	2	501
769	4	3	502
770	7	4	502
771	4	3	503
772	7	4	503
773	7	4	504
774	4	3	505
775	7	4	505
776	1	1	506
777	388	1	507
778	390	1	507
779	389	1	507
780	392	1	507
781	29	3	508
782	35	1	508
783	3	1	508
784	21	1	509
785	29	1	510
786	29	6	511
787	33	1	512
788	29	1	513
789	1	1	513
790	387	1	514
791	388	1	514
792	390	1	514
793	389	1	514
794	392	1	514
795	387	1	515
796	388	1	515
797	389	1	515
798	390	1	515
799	387	1	516
800	388	2	516
801	389	3	516
802	390	1	516
803	391	1	517
804	393	1	518
805	391	1	519
806	419	2	520
807	418	5	520
808	443	1	521
809	4	3	522
810	7	4	522
811	4	3	523
812	7	4	523
813	4	1	524
814	4	2	525
815	4	3	526
816	7	4	526
817	4	3	527
818	7	4	527
819	7	4	528
820	4	3	529
821	7	4	529
822	4	3	530
823	7	4	530
824	4	3	531
825	7	4	531
826	4	1	532
827	4	2	533
828	4	3	534
829	7	4	534
830	4	3	535
831	7	4	535
832	7	4	536
833	4	3	537
834	7	4	537
835	4	3	538
836	7	4	538
837	4	3	539
838	7	4	539
839	4	1	540
840	4	2	541
841	4	3	542
842	7	4	542
843	4	3	543
844	7	4	543
845	7	4	544
846	4	3	545
847	7	4	545
848	4	3	546
849	7	4	546
850	4	3	547
851	7	4	547
852	4	1	548
853	4	2	549
854	4	3	550
855	7	4	550
856	4	3	551
857	7	4	551
858	7	4	552
859	4	3	553
860	7	4	553
861	388	1	554
862	4	3	555
863	7	4	555
864	4	3	556
865	7	4	556
866	4	1	557
867	4	2	558
868	4	3	559
869	7	4	559
870	4	3	560
871	7	4	560
872	7	4	561
873	4	3	562
874	7	4	562
875	4	3	563
876	7	4	563
877	4	3	564
878	7	4	564
879	4	1	565
880	4	2	566
881	4	3	567
882	7	4	567
883	4	3	568
884	7	4	568
885	7	4	569
886	4	3	570
887	7	4	570
888	388	1	571
889	390	1	572
890	387	1	573
891	35	1	575
892	35	1	576
893	35	1	577
894	35	1	578
895	35	1	579
896	35	1	580
897	35	1	581
898	35	1	582
899	35	1	583
900	35	1	584
901	35	1	585
902	35	1	586
903	35	1	587
904	35	1	588
905	35	1	589
906	35	1	590
907	35	1	591
908	35	1	592
909	35	1	593
910	35	1	594
911	35	1	595
912	35	1	596
913	35	1	597
914	35	1	598
915	35	1	599
916	35	1	600
917	35	1	601
918	35	1	602
919	35	1	603
920	35	1	604
921	35	1	605
922	35	1	606
923	35	1	607
924	35	1	608
925	35	1	609
926	35	1	610
927	35	1	611
928	35	1	612
929	35	1	613
930	4	3	614
931	7	4	614
932	4	3	615
933	7	4	615
934	4	1	616
935	4	2	617
936	4	3	618
937	7	4	618
938	4	3	619
939	7	4	619
940	7	4	620
941	4	3	621
942	7	4	621
943	35	1	622
944	35	1	623
945	35	1	624
946	35	1	625
947	35	1	626
948	35	1	627
949	35	1	628
950	35	1	629
951	35	1	630
952	4	3	631
953	7	4	631
954	4	3	632
955	7	4	632
956	4	1	633
957	4	2	634
958	4	3	635
959	7	4	635
960	4	3	636
961	7	4	636
962	7	4	637
963	4	3	638
964	7	4	638
965	4	3	639
966	7	4	639
967	4	3	640
968	7	4	640
969	4	1	641
970	4	2	642
971	4	3	643
972	7	4	643
973	4	3	644
974	7	4	644
975	7	4	645
976	4	3	646
977	7	4	646
978	4	3	647
979	7	4	647
980	4	3	648
981	7	4	648
982	4	1	649
983	4	2	650
984	4	3	651
985	7	4	651
986	4	3	652
987	7	4	652
988	7	4	653
989	4	3	654
990	7	4	654
991	4	3	655
992	7	4	655
993	4	3	656
994	7	4	656
995	4	1	657
996	4	2	658
997	4	3	659
998	7	4	659
999	4	3	660
1000	7	4	660
1001	7	4	661
1002	4	3	662
1003	7	4	662
1004	4	3	663
1005	7	4	663
1006	4	3	664
1007	7	4	664
1008	4	1	665
1009	4	2	666
1010	4	3	667
1011	7	4	667
1012	4	3	668
1013	7	4	668
1014	7	4	669
1015	4	3	670
1016	7	4	670
1017	387	1	671
1018	388	1	672
1019	388	1	673
1020	388	1	674
1021	35	1	675
1022	35	1	676
1023	35	1	677
1024	388	1	678
1025	388	1	679
1026	388	1	680
1027	388	1	681
1028	388	1	682
1029	388	1	683
1030	388	1	684
1031	388	1	685
1032	388	1	686
1033	390	1	687
1034	390	1	688
1035	389	1	689
1036	4	1	690
1037	4	3	691
1038	7	4	691
1039	4	3	692
1040	7	4	692
1041	4	1	693
1042	4	2	694
1043	4	3	695
1044	7	4	695
1045	4	3	696
1046	7	4	696
1047	7	4	697
1048	4	3	698
1049	7	4	698
1050	4	3	699
1051	7	4	699
1052	4	3	700
1053	7	4	700
1054	4	1	701
1055	4	2	702
1056	4	3	703
1057	7	4	703
1058	4	3	704
1059	7	4	704
1060	7	4	705
1061	4	3	706
1062	7	4	706
1063	4	3	707
1064	7	4	707
1065	4	3	708
1066	7	4	708
1067	4	1	709
1068	4	2	710
1069	4	3	711
1070	7	4	711
1071	4	3	712
1072	7	4	712
1073	7	4	713
1074	4	3	714
1075	7	4	714
1076	4	3	715
1077	7	4	715
1078	4	3	716
1079	7	4	716
1080	4	1	717
1081	4	2	718
1082	4	3	719
1083	7	4	719
1084	4	3	720
1085	7	4	720
1086	7	4	721
1087	4	3	722
1088	7	4	722
1089	4	3	723
1090	7	4	723
1091	4	3	724
1092	7	4	724
1093	4	1	725
1094	4	2	726
1095	4	3	727
1096	7	4	727
1097	4	3	728
1098	7	4	728
1099	7	4	729
1100	4	3	730
1101	7	4	730
1102	4	3	731
1103	7	4	731
1104	4	3	732
1105	7	4	732
1106	4	1	733
1107	4	2	734
1108	4	3	735
1109	7	4	735
1110	4	3	736
1111	7	4	736
1112	7	4	737
1113	4	3	738
1114	7	4	738
1115	4	3	739
1116	7	4	739
1117	4	3	740
1118	7	4	740
1119	4	1	741
1120	4	2	742
1121	4	3	743
1122	7	4	743
1123	4	3	744
1124	7	4	744
1125	7	4	745
1126	4	3	746
1127	7	4	746
1128	4	3	747
1129	7	4	747
1130	4	3	748
1131	7	4	748
1132	4	1	749
1133	4	2	750
1134	4	3	751
1135	7	4	751
1136	4	3	752
1137	7	4	752
1138	7	4	753
1139	4	3	754
1140	7	4	754
1141	4	3	755
1142	7	4	755
1143	4	3	756
1144	7	4	756
1145	4	1	757
1146	4	2	758
1147	4	3	759
1148	7	4	759
1149	4	3	760
1150	7	4	760
1151	7	4	761
1152	4	3	762
1153	7	4	762
1154	4	3	763
1155	7	4	763
1156	4	3	764
1157	7	4	764
1158	4	1	765
1159	4	2	766
1160	4	3	767
1161	7	4	767
1162	4	3	768
1163	7	4	768
1164	7	4	769
1165	4	3	770
1166	7	4	770
1167	4	3	771
1168	7	4	771
1169	4	3	772
1170	7	4	772
1171	4	1	773
1172	4	2	774
1173	4	3	775
1174	7	4	775
1175	4	3	776
1176	7	4	776
1177	7	4	777
1178	4	3	778
1179	7	4	778
1180	4	3	779
1181	7	4	779
1182	4	3	780
1183	7	4	780
1184	4	1	781
1185	4	2	782
1186	4	3	783
1187	7	4	783
1188	4	3	784
1189	7	4	784
1190	7	4	785
1191	4	3	786
1192	7	4	786
1193	4	3	787
1194	7	4	787
1195	4	3	788
1196	7	4	788
1197	4	1	789
1198	4	2	790
1199	4	3	791
1200	7	4	791
1201	4	3	792
1202	7	4	792
1203	7	4	793
1204	4	3	794
1205	7	4	794
1206	4	3	795
1207	7	4	795
1208	4	3	796
1209	7	4	796
1210	4	1	797
1211	4	2	798
1212	4	3	799
1213	7	4	799
1214	4	3	800
1215	7	4	800
1216	7	4	801
1217	4	3	802
1218	7	4	802
1219	29	1	803
1220	34	1	803
1221	34	1	804
1222	29	1	804
1223	30	1	804
1224	4	3	805
1225	7	4	805
1226	4	3	806
1227	7	4	806
1228	4	1	807
1229	4	2	808
1230	4	3	809
1231	7	4	809
1232	4	3	810
1233	7	4	810
1234	7	4	811
1235	4	3	812
1236	7	4	812
1237	4	3	813
1238	7	4	813
1239	4	3	814
1240	7	4	814
1241	4	1	815
1242	4	2	816
1243	4	3	817
1244	7	4	817
1245	4	3	818
1246	7	4	818
1247	7	4	819
1248	4	3	820
1249	7	4	820
1250	4	3	821
1251	7	4	821
1252	4	3	822
1253	7	4	822
1254	4	1	823
1255	4	2	824
1256	4	3	825
1257	7	4	825
1258	4	3	826
1259	7	4	826
1260	7	4	827
1261	4	3	828
1262	7	4	828
1263	4	3	829
1264	7	4	829
1265	4	3	830
1266	7	4	830
1267	4	1	831
1268	4	2	832
1269	4	3	833
1270	7	4	833
1271	4	3	834
1272	7	4	834
1273	7	4	835
1274	4	3	836
1275	7	4	836
1276	4	3	837
1277	7	4	837
1278	4	3	838
1279	7	4	838
1280	4	1	839
1281	4	2	840
1282	4	3	841
1283	7	4	841
1284	4	3	842
1285	7	4	842
1286	7	4	843
1287	4	3	844
1288	7	4	844
1289	4	3	845
1290	7	4	845
1291	4	3	846
1292	7	4	846
1293	4	1	847
1294	4	2	848
1295	4	3	849
1296	7	4	849
1297	4	3	850
1298	7	4	850
1299	7	4	851
1300	4	3	852
1301	7	4	852
1302	4	3	853
1303	7	4	853
1304	4	3	854
1305	7	4	854
1306	4	1	855
1307	4	2	856
1308	4	3	857
1309	7	4	857
1310	4	3	858
1311	7	4	858
1312	7	4	859
1313	4	3	860
1314	7	4	860
1315	4	3	861
1316	7	4	861
1317	4	3	862
1318	7	4	862
1319	4	1	863
1320	4	2	864
1321	4	3	865
1322	7	4	865
1323	4	3	866
1324	7	4	866
1325	7	4	867
1326	4	3	868
1327	7	4	868
1328	4	3	869
1329	7	4	869
1330	4	3	870
1331	7	4	870
1332	4	1	871
1333	4	2	872
1334	4	3	873
1335	7	4	873
1336	4	3	874
1337	7	4	874
1338	7	4	875
1339	4	3	876
1340	7	4	876
1341	4	3	877
1342	7	4	877
1343	4	3	878
1344	7	4	878
1345	4	1	879
1346	4	2	880
1347	4	3	881
1348	7	4	881
1349	4	3	882
1350	7	4	882
1351	7	4	883
1352	4	3	884
1353	7	4	884
1354	4	3	885
1355	7	4	885
1356	4	3	886
1357	7	4	886
1358	4	1	887
1359	4	2	888
1360	4	3	889
1361	7	4	889
1362	4	3	890
1363	7	4	890
1364	7	4	891
1365	4	3	892
1366	7	4	892
1367	4	3	893
1368	7	4	893
1369	4	3	894
1370	7	4	894
1371	4	1	895
1372	4	2	896
1373	4	3	897
1374	7	4	897
1375	4	3	898
1376	7	4	898
1377	7	4	899
1378	4	3	900
1379	7	4	900
1380	4	3	901
1381	7	4	901
1382	4	3	902
1383	7	4	902
1384	4	1	903
1385	4	2	904
1386	4	3	905
1387	7	4	905
1388	4	3	906
1389	7	4	906
1390	7	4	907
1391	4	3	908
1392	7	4	908
1393	4	3	909
1394	7	4	909
1395	4	3	910
1396	7	4	910
1397	4	1	911
1398	4	2	912
1399	4	3	913
1400	7	4	913
1401	4	3	914
1402	7	4	914
1403	7	4	915
1404	4	3	916
1405	7	4	916
1406	4	3	917
1407	7	4	917
1408	4	3	918
1409	7	4	918
1410	4	1	919
1411	4	2	920
1412	4	3	921
1413	7	4	921
1414	4	3	922
1415	7	4	922
1416	7	4	923
1417	4	3	924
1418	7	4	924
1419	4	3	925
1420	7	4	925
1421	4	3	926
1422	7	4	926
1423	4	1	927
1424	4	2	928
1425	4	3	929
1426	7	4	929
1427	4	3	930
1428	7	4	930
1429	7	4	931
1430	4	3	932
1431	7	4	932
1432	4	3	933
1433	7	4	933
1434	4	3	934
1435	7	4	934
1436	4	1	935
1437	4	2	936
1438	4	3	937
1439	7	4	937
1440	4	3	938
1441	7	4	938
1442	7	4	939
1443	4	3	940
1444	7	4	940
1445	4	3	941
1446	7	4	941
1447	4	3	942
1448	7	4	942
1449	4	1	943
1450	4	2	944
1451	4	3	945
1452	7	4	945
1453	4	3	946
1454	7	4	946
1455	7	4	947
1456	4	3	948
1457	7	4	948
1458	4	3	949
1459	7	4	949
1460	4	3	950
1461	7	4	950
1462	4	1	951
1463	4	2	952
1464	4	3	953
1465	7	4	953
1466	4	3	954
1467	7	4	954
1468	7	4	955
1469	4	3	956
1470	7	4	956
1471	4	3	957
1472	7	4	957
1473	4	3	958
1474	7	4	958
1475	4	1	959
1476	4	2	960
1477	4	3	961
1478	7	4	961
1479	4	3	962
1480	7	4	962
1481	7	4	963
1482	4	3	964
1483	7	4	964
1484	4	3	965
1485	7	4	965
1486	4	3	966
1487	7	4	966
1488	4	1	967
1489	4	2	968
1490	4	3	969
1491	7	4	969
1492	4	3	970
1493	7	4	970
1494	7	4	971
1495	4	3	972
1496	7	4	972
1497	4	3	973
1498	7	4	973
1499	4	3	974
1500	7	4	974
1501	4	1	975
1502	4	2	976
1503	4	3	977
1504	7	4	977
1505	4	3	978
1506	7	4	978
1507	7	4	979
1508	4	3	980
1509	7	4	980
1510	4	3	981
1511	7	4	981
1512	4	3	982
1513	7	4	982
1514	4	1	983
1515	4	2	984
1516	4	3	985
1517	7	4	985
1518	4	3	986
1519	7	4	986
1520	7	4	987
1521	4	3	988
1522	7	4	988
1523	4	3	989
1524	7	4	989
1525	4	3	990
1526	7	4	990
1527	4	1	991
1528	4	2	992
1529	4	3	993
1530	7	4	993
1531	4	3	994
1532	7	4	994
1533	7	4	995
1534	4	3	996
1535	7	4	996
1536	4	3	997
1537	7	4	997
1538	4	3	998
1539	7	4	998
1540	4	1	999
1541	4	2	1000
1542	4	3	1001
1543	7	4	1001
1544	4	3	1002
1545	7	4	1002
1546	7	4	1003
1547	4	3	1004
1548	7	4	1004
1549	4	3	1005
1550	7	4	1005
1551	4	3	1006
1552	7	4	1006
1553	4	1	1007
1554	4	2	1008
1555	4	3	1009
1556	7	4	1009
1557	4	3	1010
1558	7	4	1010
1559	7	4	1011
1560	4	3	1012
1561	7	4	1012
1562	4	3	1013
1563	7	4	1013
1564	4	3	1014
1565	7	4	1014
1566	4	1	1015
1567	4	2	1016
1568	4	3	1017
1569	7	4	1017
1570	4	3	1018
1571	7	4	1018
1572	7	4	1019
1573	4	3	1020
1574	7	4	1020
1575	4	3	1021
1576	7	4	1021
1577	4	3	1022
1578	7	4	1022
1579	4	1	1023
1580	4	2	1024
1581	4	3	1025
1582	7	4	1025
1583	4	3	1026
1584	7	4	1026
1585	7	4	1027
1586	4	3	1028
1587	7	4	1028
1588	4	3	1029
1589	7	4	1029
1590	4	3	1030
1591	7	4	1030
1592	4	1	1031
1593	4	2	1032
1594	4	3	1033
1595	7	4	1033
1596	4	3	1034
1597	7	4	1034
1598	7	4	1035
1599	4	3	1036
1600	7	4	1036
1601	391	2	1037
1602	398	1	1037
1603	428	2	1037
\.


--
-- Data for Name: t_payment; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_payment (id, table_session_id, type, created_at, acknowledged_at, acknowledged_by) FROM stdin;
1	1	CARD	2023-08-28 15:48:20.238377	2023-08-28 16:02:02.40383	1
2	1	CARD	2023-08-28 15:48:46.366856	2023-08-28 16:02:02.403869	1
3	1	CARD	2023-08-28 15:54:05.350931	2023-08-28 16:02:02.403805	1
4	1	CARD	2023-08-28 15:54:12.2218	2023-08-28 16:02:02.403812	1
5	1	CARD	2023-08-28 15:54:42.69247	2023-08-28 16:02:02.40386	1
6	1	CARD	2023-08-28 16:00:23.774212	2023-08-28 16:02:02.403858	1
7	1	CARD	2023-08-28 16:02:14.084446	2023-08-28 16:02:22.04258	1
8	1	CARD	2023-08-28 16:02:19.619888	2023-08-28 16:02:22.042593	1
9	1	CARD	2023-08-28 16:02:26.539644	2023-08-28 16:02:32.160262	1
10	1	CARD	2023-08-28 16:02:28.062546	2023-08-28 16:02:32.160278	1
11	1	CARD	2023-08-28 16:02:28.644994	2023-08-28 16:02:32.160275	1
12	1	CARD	2023-08-28 16:02:33.760208	2023-08-28 16:02:35.089606	1
13	1	CARD	2023-08-28 16:02:38.087911	2023-08-28 16:02:40.222535	1
14	28	CARD	2023-08-31 13:24:59.62205	2023-08-31 13:25:03.06623	1
15	28	CARD	2023-08-31 13:31:42.20076	2023-08-31 13:31:46.705622	1
56	4	CASH	2023-09-19 22:13:08.817611	\N	\N
57	4	CASH	2023-09-19 22:44:37.585722	\N	\N
16	22	CASH	2023-09-11 15:50:34.771996	2023-09-29 14:51:52.336265	1
17	22	CASH	2023-09-11 15:50:44.564179	2023-09-29 14:51:52.33626	1
49	22	CASH	2023-09-11 16:12:39.149911	2023-09-29 14:51:52.336271	1
50	22	CASH	2023-09-11 16:17:15.757051	2023-09-29 14:51:52.336233	1
51	22	CARD	2023-09-11 16:18:17.644345	2023-09-29 14:51:52.336262	1
52	22	CARD	2023-09-12 09:07:46.959137	2023-09-29 14:51:52.336204	1
53	22	CASH	2023-09-12 09:42:08.350076	2023-09-29 14:51:52.336277	1
54	22	CASH	2023-09-13 14:16:32.315422	2023-09-29 14:51:52.336272	1
55	22	CASH	2023-09-13 22:22:07.858129	2023-09-29 14:51:52.336274	1
63	29	CARD	2023-10-22 11:46:10.4345	2023-10-22 11:46:22.292042	1
64	29	CARD	2023-10-22 11:46:28.933314	2023-10-22 12:26:24.839909	1
65	29	CARD	2023-10-22 12:26:15.042035	2023-10-22 12:26:24.839896	1
60	22	CARD	2023-10-03 12:49:22.885647	2023-10-22 12:26:28.609815	1
61	22	CASH	2023-10-13 17:38:55.681111	2023-10-22 12:26:28.60979	1
62	22	CASH	2023-10-13 18:09:01.170405	2023-10-22 12:26:28.609792	1
66	29	CARD	2023-10-22 12:26:45.051634	2023-10-22 12:27:14.348488	1
67	29	CARD	2023-10-22 12:27:18.693314	2023-10-22 12:29:39.917951	1
68	29	CARD	2023-10-22 12:29:46.688096	2023-10-22 12:29:50.710056	1
69	29	CARD	2023-10-22 12:30:23.804307	2023-10-22 12:32:55.281986	1
70	29	CARD	2023-10-22 12:32:27.673434	2023-10-22 12:32:55.281978	1
71	29	CARD	2023-10-22 12:33:01.87653	2023-10-22 12:33:07.864405	1
72	29	CARD	2023-10-22 12:33:20.677648	2023-10-22 12:33:30.657587	1
73	29	CARD	2023-10-22 12:34:01.018985	2023-10-22 12:34:16.664167	2
74	29	CARD	2023-10-22 12:34:26.518686	2023-10-22 12:52:42.913662	1
75	29	CARD	2023-10-22 12:52:52.49218	2023-10-22 13:00:44.986244	1
76	29	CARD	2023-10-22 12:53:07.853375	2023-10-22 13:00:44.986242	1
77	29	CARD	2023-10-22 12:54:26.618805	2023-10-22 13:00:44.986235	1
78	29	CARD	2023-10-22 13:00:53.552274	2023-10-22 13:19:40.741254	2
79	29	CARD	2023-10-22 13:01:08.771091	2023-10-22 13:19:40.741264	2
59	31	CASH	2023-09-20 22:14:57.832266	2023-10-24 21:27:09.019807	2
58	31	CASH	2023-09-20 21:21:10.7372	2023-10-24 21:27:09.019792	2
80	29	CARD	2023-10-24 21:27:59.006959	2023-10-24 21:28:03.449633	2
85	29	CARD	2023-10-24 21:28:22.302861	2023-10-24 21:29:49.397727	2
84	29	CARD	2023-10-24 21:28:21.579378	2023-10-24 21:29:49.397755	2
83	29	CARD	2023-10-24 21:28:20.856091	2023-10-24 21:29:49.397736	2
82	29	CARD	2023-10-24 21:28:20.146914	2023-10-24 21:29:49.397759	2
81	29	CARD	2023-10-24 21:28:08.496671	2023-10-24 21:29:49.397757	2
86	36	CASH	2023-10-28 18:09:46.292165	2023-10-28 18:10:02.041644	2
87	26	CARD	2023-11-01 00:08:42.93311	2023-11-01 00:08:59.59281	2
88	45	CARD	2023-11-18 16:54:21.343878	\N	\N
89	30	CARD	2023-11-19 21:03:51.62891	2023-11-19 21:12:30.283382	1
90	30	CASH	2023-11-19 21:05:16.598609	2023-11-19 21:12:30.283379	1
91	6	CASH	2023-11-30 17:40:22.285519	2023-11-30 17:40:36.427739	5
92	6	CARD	2023-11-30 17:40:27.343192	2023-11-30 17:40:36.427777	5
93	6	CASH	2023-11-30 17:40:50.188408	2023-11-30 17:41:01.223793	2
94	39	CASH	2023-12-01 05:49:08.656789	2023-12-01 05:49:21.571915	1
95	39	CASH	2023-12-01 05:49:52.696447	2023-12-01 05:50:12.69703	1
96	39	CARD	2023-12-01 05:50:31.278539	2023-12-01 05:50:42.880233	1
97	39	CASH	2023-12-01 08:42:58.940754	2023-12-01 08:47:12.172723	1
98	39	CARD	2023-12-01 08:43:08.993413	2023-12-01 08:47:12.172725	1
99	39	CARD	2023-12-01 08:43:40.048049	2023-12-01 08:47:12.172727	1
100	39	CASH	2023-12-01 08:43:50.881262	2023-12-01 08:47:12.172726	1
101	74	CASH	2023-12-05 18:12:44.04167	2023-12-05 18:13:08.602454	2
102	59	CASH	2023-12-05 21:15:05.320335	2023-12-05 21:18:29.716208	3
103	80	CASH	2023-12-06 18:07:53.085555	2023-12-06 18:08:02.55045	3
104	74	CASH	2023-12-06 18:30:20.122688	2023-12-19 22:43:39.702158	3
105	74	CASH	2023-12-06 18:30:27.452731	2023-12-19 22:43:39.702118	3
106	92	CASH	2023-12-20 07:53:06.554582	\N	\N
107	82	CASH	2023-12-23 08:41:19.635095	2023-12-23 08:41:23.432429	2
108	93	CASH	2023-12-25 10:13:59.161042	\N	\N
109	103	CARD	2023-12-25 10:34:41.342142	2023-12-25 10:35:16.374545	2
110	103	CASH	2023-12-25 10:35:45.571375	2023-12-25 11:55:34.853602	2
111	103	CASH	2023-12-25 10:36:23.737735	2023-12-25 11:55:34.853563	2
113	82	CARD	2023-12-28 19:12:41.021766	2023-12-28 19:12:54.583275	7
119	109	CARD	2024-03-19 14:08:52.763577	2024-03-20 21:03:37.189023	12
120	109	CASH	2024-03-19 14:10:27.843187	2024-03-20 21:03:37.189006	12
122	112	CASH	2024-03-21 11:36:33.747377	2024-03-21 11:36:49.950317	12
121	105	CARD	2024-03-19 14:12:30.967555	2024-03-22 10:04:13.291031	1
123	105	CARD	2024-03-22 00:04:19.738171	2024-03-22 10:04:13.291033	1
124	105	CARD	2024-03-22 02:04:33.443812	2024-03-22 10:04:13.291016	1
125	5	CASH	2024-03-22 10:22:57.512197	2024-03-22 10:23:06.11385	1
126	5	CASH	2024-03-22 10:24:30.413465	2024-03-22 10:24:46.953258	1
127	5	CARD	2024-03-22 10:24:43.14042	2024-03-22 10:24:46.953246	1
115	122	CARD	2024-03-06 12:35:11.726663	2024-04-03 17:37:36.961348	12
118	122	CASH	2024-03-17 12:19:46.829883	2024-04-03 17:37:36.961343	12
112	31	CARD	2023-12-26 14:05:17.173232	2024-04-14 23:26:50.248483	5
114	31	CARD	2023-12-28 22:03:09.441033	2024-04-14 23:26:50.248496	5
116	108	CASH	2024-03-14 12:31:41.385009	2024-04-14 23:37:54.423954	12
146	133	CARD	2024-04-03 14:56:37.755261	\N	\N
147	134	CARD	2024-04-03 14:57:23.493413	2024-04-03 14:57:23.794664	13
148	135	CARD	2024-04-03 15:06:47.325299	2024-04-03 15:06:48.586299	13
128	5	CASH	2024-03-25 16:36:24.922913	2024-04-03 15:07:47.946612	1
129	5	CARD	2024-03-25 21:10:59.84159	2024-04-03 15:07:47.946615	1
130	5	CARD	2024-03-25 19:37:35.085933	2024-04-03 15:07:47.946616	1
149	136	CARD	2024-04-03 15:10:19.72398	2024-04-03 15:10:21.051113	13
151	138	CARD	2024-04-04 08:55:05.809084	2024-04-04 08:55:07.00509	13
152	140	CARD	2024-04-04 08:55:36.245495	2024-04-04 08:55:37.326003	13
153	144	CARD	2024-04-04 09:36:29.272052	2024-04-04 09:36:30.724849	13
154	146	CASH	2024-04-04 09:37:51.451241	2024-04-04 09:37:52.812366	13
155	148	CASH	2024-04-04 09:38:14.841506	2024-04-04 09:38:16.175554	13
156	150	CARD	2024-04-04 09:38:25.386368	2024-04-04 09:38:26.673066	13
157	152	CARD	2024-04-04 09:47:50.837208	2024-04-04 09:47:53.149358	13
158	153	CARD	2024-04-04 09:48:47.680258	2024-04-04 09:48:49.98292	13
159	155	CASH	2024-04-04 09:49:37.92858	2024-04-04 09:49:39.303824	13
160	157	CARD	2024-04-04 09:49:44.365148	2024-04-04 09:49:46.551937	13
161	159	CARD	2024-04-04 09:49:53.727481	2024-04-04 09:49:54.999577	13
162	165	CASH	2024-04-04 10:01:48.652703	2024-04-04 10:01:50.022699	13
163	169	CARD	2024-04-04 10:02:00.522833	2024-04-04 10:02:02.772771	13
164	171	CARD	2024-04-04 10:02:09.955994	2024-04-04 10:02:11.705343	13
165	173	CASH	2024-04-04 10:06:03.318977	2024-04-04 10:06:04.657184	13
166	177	CARD	2024-04-04 10:06:16.519159	2024-04-04 10:06:18.761616	13
167	179	CARD	2024-04-04 10:06:26.548546	2024-04-04 10:06:27.874897	13
168	181	CASH	2024-04-05 10:43:15.874936	2024-04-05 10:44:44.682489	13
169	183	CASH	2024-04-05 10:54:04.709874	\N	\N
170	185	CASH	2024-04-05 10:54:49.758905	\N	\N
171	186	CASH	2024-04-05 11:02:45.853508	\N	\N
172	186	CARD	2024-04-05 11:02:48.799164	\N	\N
173	188	CASH	2024-04-05 11:07:30.610186	\N	\N
174	188	CARD	2024-04-05 11:07:33.485604	\N	\N
175	190	CASH	2024-04-05 11:08:36.737014	2024-04-05 11:08:40.935289	13
176	190	CARD	2024-04-05 11:08:39.601304	2024-04-05 11:08:40.935281	13
177	192	CASH	2024-04-05 11:21:45.864569	2024-04-05 11:21:50.34652	13
178	192	CARD	2024-04-05 11:21:48.958901	2024-04-05 11:21:50.346527	13
179	194	CASH	2024-04-05 11:22:14.897838	\N	\N
180	196	CASH	2024-04-05 11:23:41.838641	2024-04-05 11:23:43.186676	13
181	198	CASH	2024-04-05 11:24:12.552042	2024-04-05 11:24:14.110671	13
182	202	CASH	2024-04-05 11:24:28.847405	2024-04-05 11:24:31.096643	13
183	204	CARD	2024-04-05 11:24:35.604422	2024-04-05 11:24:37.724077	13
184	206	CARD	2024-04-05 11:24:45.110201	2024-04-05 11:24:46.359555	13
185	208	CASH	2024-04-05 11:24:54.034871	2024-04-05 11:24:55.387974	13
186	210	CASH	2024-04-05 11:25:02.92785	2024-04-05 11:25:07.184957	13
187	210	CARD	2024-04-05 11:25:05.818787	2024-04-05 11:25:07.18495	13
188	112	CASH	2024-04-05 17:36:21.500444	2024-04-05 17:36:45.442399	12
189	212	CARD	2024-04-07 05:01:25.460003	2024-04-07 05:01:28.298737	13
190	214	CARD	2024-04-07 05:03:22.143852	2024-04-07 05:03:23.586753	13
191	217	CARD	2024-04-07 05:08:48.563084	2024-04-07 05:08:50.125633	13
192	219	CASH	2024-04-08 07:34:24.160174	2024-04-08 07:34:25.601512	13
193	223	CASH	2024-04-08 07:34:41.51881	2024-04-08 07:34:43.767268	13
194	225	CARD	2024-04-08 07:34:48.69224	2024-04-08 07:34:50.877156	13
195	227	CARD	2024-04-08 07:34:59.069861	2024-04-08 07:35:00.621511	13
196	229	CASH	2024-04-08 07:35:08.716278	2024-04-08 07:35:10.237322	13
197	231	CARD	2024-04-08 07:35:18.959249	2024-04-08 07:35:20.26261	13
198	233	CASH	2024-04-08 07:35:28.700227	2024-04-08 07:35:33.089143	13
199	233	CARD	2024-04-08 07:35:31.658256	2024-04-08 07:35:33.089152	13
200	235	CARD	2024-04-08 07:35:41.27683	2024-04-08 07:35:42.699466	13
201	240	CASH	2024-04-08 07:44:25.196937	\N	\N
203	250	CASH	2024-04-08 07:44:35.654942	\N	\N
202	251	CARD	2024-04-08 07:44:35.523359	2024-04-08 07:44:36.759186	13
204	255	CARD	2024-04-08 07:44:39.335847	\N	\N
205	258	CARD	2024-04-08 07:44:44.13969	\N	\N
206	290	CARD	2024-04-08 08:02:49.744261	2024-04-08 08:02:51.290802	13
207	292	CASH	2024-04-08 08:12:17.451134	2024-04-08 08:12:17.982962	13
208	296	CASH	2024-04-08 08:12:24.832852	2024-04-08 08:12:25.661374	13
209	298	CARD	2024-04-08 08:12:27.828421	2024-04-08 08:12:28.797288	13
210	300	CARD	2024-04-08 08:12:32.1563	2024-04-08 08:12:32.678864	13
211	302	CASH	2024-04-08 08:12:36.192995	2024-04-08 08:12:36.713683	13
212	304	CARD	2024-04-08 08:12:40.454233	2024-04-08 08:12:40.969697	13
213	306	CASH	2024-04-08 08:12:44.437213	2024-04-08 08:12:46.063409	13
214	306	CARD	2024-04-08 08:12:45.540571	2024-04-08 08:12:46.063405	13
215	308	CARD	2024-04-08 08:12:49.519348	2024-04-08 08:12:50.053397	13
216	315	CASH	2024-04-08 08:23:54.791844	2024-04-08 08:23:55.343937	13
217	319	CASH	2024-04-08 08:24:02.075397	2024-04-08 08:24:02.980307	13
218	321	CARD	2024-04-08 08:24:05.237249	2024-04-08 08:24:06.239027	13
219	323	CARD	2024-04-08 08:24:09.745944	2024-04-08 08:24:10.301656	13
220	325	CASH	2024-04-08 08:24:13.952447	2024-04-08 08:24:14.487571	13
221	327	CARD	2024-04-08 08:24:18.454237	2024-04-08 08:24:18.990103	13
222	329	CASH	2024-04-08 08:24:22.53168	2024-04-08 08:24:24.233974	13
223	329	CARD	2024-04-08 08:24:23.697453	2024-04-08 08:24:24.233969	13
224	331	CARD	2024-04-08 08:24:27.799451	2024-04-08 08:24:28.36441	13
225	334	CASH	2024-04-08 08:26:26.8356	2024-04-08 08:26:27.396678	13
226	338	CASH	2024-04-08 08:26:34.314776	2024-04-08 08:26:35.142029	13
227	340	CARD	2024-04-08 08:26:37.372917	2024-04-08 08:26:38.328875	13
228	342	CARD	2024-04-08 08:26:41.65968	2024-04-08 08:26:42.174812	13
229	344	CASH	2024-04-08 08:26:45.760995	2024-04-08 08:26:46.277352	13
230	346	CARD	2024-04-08 08:26:49.983402	2024-04-08 08:26:50.509133	13
231	348	CASH	2024-04-08 08:26:53.925115	2024-04-08 08:26:55.576406	13
232	348	CARD	2024-04-08 08:26:55.050575	2024-04-08 08:26:55.576398	13
233	350	CARD	2024-04-08 08:26:59.075083	2024-04-08 08:26:59.588665	13
234	355	CASH	2024-04-08 08:27:50.238677	2024-04-08 08:27:51.126798	13
235	359	CASH	2024-04-08 08:28:01.515671	2024-04-08 08:28:02.937231	13
236	361	CARD	2024-04-08 08:28:06.382234	2024-04-08 08:28:07.920494	13
237	363	CARD	2024-04-08 08:28:13.22184	2024-04-08 08:28:14.092981	13
238	365	CASH	2024-04-08 08:28:19.604692	2024-04-08 08:28:20.474008	13
239	367	CARD	2024-04-08 08:28:26.261747	2024-04-08 08:28:27.13509	13
240	369	CASH	2024-04-08 08:28:32.611089	2024-04-08 08:28:35.343526	13
139	108	CASH	2024-03-29 09:46:34.59022	2024-04-14 23:37:54.423867	12
140	108	CARD	2024-03-29 09:53:41.10696	2024-04-14 23:37:54.423941	12
241	369	CARD	2024-04-08 08:28:34.481666	2024-04-08 08:28:35.343523	13
242	371	CARD	2024-04-08 08:28:40.744289	2024-04-08 08:28:41.6128	13
243	378	CASH	2024-04-08 08:57:17.893492	2024-04-08 08:57:18.468296	13
244	382	CASH	2024-04-08 08:57:24.873774	2024-04-08 08:57:25.727575	13
245	384	CARD	2024-04-08 08:57:27.921201	2024-04-08 08:57:28.901403	13
246	386	CARD	2024-04-08 08:57:32.359462	2024-04-08 08:57:32.909496	13
247	388	CASH	2024-04-08 08:57:36.389136	2024-04-08 08:57:36.921937	13
248	390	CARD	2024-04-08 08:57:40.642672	2024-04-08 08:57:41.199788	13
249	392	CASH	2024-04-08 08:57:44.669487	2024-04-08 08:57:46.339646	13
250	392	CARD	2024-04-08 08:57:45.816253	2024-04-08 08:57:46.33964	13
251	394	CARD	2024-04-08 08:57:49.812781	2024-04-08 08:57:50.340744	13
252	397	CASH	2024-04-08 09:07:17.683889	2024-04-08 09:07:18.624414	13
253	401	CASH	2024-04-08 09:07:29.084946	2024-04-08 09:07:30.475435	13
254	403	CARD	2024-04-08 09:07:33.846926	2024-04-08 09:07:35.368867	13
255	405	CARD	2024-04-08 09:07:40.706621	2024-04-08 09:07:41.583098	13
256	407	CASH	2024-04-08 09:07:47.091415	2024-04-08 09:07:47.957161	13
257	409	CARD	2024-04-08 09:07:53.726931	2024-04-08 09:07:54.602248	13
258	411	CASH	2024-04-08 09:08:00.017614	2024-04-08 09:08:02.803784	13
259	411	CARD	2024-04-08 09:08:01.90677	2024-04-08 09:08:02.803788	13
260	413	CARD	2024-04-08 09:08:08.243926	2024-04-08 09:08:09.106256	13
261	418	CASH	2024-04-08 09:09:19.909977	2024-04-08 09:09:20.715244	13
262	422	CASH	2024-04-08 09:09:30.160837	2024-04-08 09:09:31.415872	13
263	424	CARD	2024-04-08 09:09:34.495149	2024-04-08 09:09:35.894437	13
264	426	CARD	2024-04-08 09:09:40.664445	2024-04-08 09:09:41.488164	13
265	428	CASH	2024-04-08 09:09:46.435181	2024-04-08 09:09:47.234109	13
266	430	CARD	2024-04-08 09:09:52.584456	2024-04-08 09:09:53.364404	13
267	432	CASH	2024-04-08 09:09:58.267039	2024-04-08 09:10:00.760485	13
268	432	CARD	2024-04-08 09:09:59.973823	2024-04-08 09:10:00.76048	13
269	434	CARD	2024-04-08 09:10:06.00917	2024-04-08 09:10:06.784713	13
270	439	CASH	2024-04-08 09:12:41.664992	2024-04-08 09:12:42.555464	13
271	443	CASH	2024-04-08 09:12:52.87173	2024-04-08 09:12:54.266969	13
272	445	CARD	2024-04-08 09:12:57.633357	2024-04-08 09:12:59.192003	13
273	447	CARD	2024-04-08 09:13:04.490308	2024-04-08 09:13:05.362894	13
274	449	CASH	2024-04-08 09:13:10.835714	2024-04-08 09:13:11.694842	13
275	451	CARD	2024-04-08 09:13:17.498769	2024-04-08 09:13:18.356921	13
276	453	CASH	2024-04-08 09:13:23.744792	2024-04-08 09:13:26.479308	13
277	453	CARD	2024-04-08 09:13:25.615927	2024-04-08 09:13:26.479312	13
278	455	CARD	2024-04-08 09:13:31.969607	2024-04-08 09:13:32.827823	13
279	462	CASH	2024-04-08 09:35:49.09209	2024-04-08 09:35:50.142058	13
280	466	CASH	2024-04-08 09:36:01.454298	2024-04-08 09:36:03.039296	13
281	468	CARD	2024-04-08 09:36:06.911629	2024-04-08 09:36:08.590216	13
282	470	CARD	2024-04-08 09:36:14.302083	2024-04-08 09:36:15.232554	13
283	472	CASH	2024-04-08 09:36:21.056086	2024-04-08 09:36:21.992425	13
284	474	CARD	2024-04-08 09:36:28.240034	2024-04-08 09:36:29.15001	13
285	476	CASH	2024-04-08 09:36:34.910013	2024-04-08 09:36:37.807158	13
286	476	CARD	2024-04-08 09:36:36.908554	2024-04-08 09:36:37.80715	13
287	478	CARD	2024-04-08 09:36:43.587557	2024-04-08 09:36:44.499176	13
288	481	CASH	2024-04-09 09:08:43.180588	2024-04-09 09:08:44.353397	13
289	485	CASH	2024-04-09 09:08:56.764894	2024-04-09 09:08:58.320608	13
290	487	CARD	2024-04-09 09:09:02.351691	2024-04-09 09:09:04.21857	13
291	489	CARD	2024-04-09 09:09:10.158455	2024-04-09 09:09:11.122034	13
292	491	CASH	2024-04-09 09:09:17.196102	2024-04-09 09:09:18.130328	13
293	493	CARD	2024-04-09 09:09:24.489798	2024-04-09 09:09:25.437922	13
294	495	CASH	2024-04-09 09:09:31.228651	2024-04-09 09:09:34.240988	13
295	495	CARD	2024-04-09 09:09:33.28751	2024-04-09 09:09:34.240996	13
296	497	CARD	2024-04-09 09:09:40.152924	2024-04-09 09:09:41.073325	13
297	508	CASH	2024-04-09 09:43:24.794575	2024-04-09 09:43:26.266309	13
298	512	CASH	2024-04-09 09:43:43.19882	2024-04-09 09:43:45.382891	13
299	514	CARD	2024-04-09 09:43:50.851069	2024-04-09 09:43:53.204438	13
300	518	CASH	2024-04-09 09:44:07.29905	2024-04-09 09:44:08.709083	13
301	520	CARD	2024-04-09 09:44:18.201151	2024-04-09 09:44:19.630071	13
302	522	CASH	2024-04-09 09:44:28.212276	2024-04-09 09:44:32.876691	13
303	522	CARD	2024-04-09 09:44:31.437405	2024-04-09 09:44:32.8767	13
304	524	CARD	2024-04-09 09:44:41.329817	2024-04-09 09:44:42.754322	13
305	530	CARD	2024-04-09 09:47:16.242909	2024-04-09 09:47:17.724976	13
306	532	CASH	2024-04-09 10:25:34.832687	2024-04-09 10:25:36.32381	13
307	536	CASH	2024-04-09 10:25:52.220046	2024-04-09 10:25:54.324368	13
308	538	CARD	2024-04-09 10:25:59.531284	2024-04-09 10:26:01.792384	13
309	540	CARD	2024-04-09 10:26:09.901919	2024-04-09 10:26:11.289259	13
310	542	CASH	2024-04-09 10:26:19.921429	2024-04-09 10:26:21.31496	13
311	544	CARD	2024-04-09 10:26:30.301881	2024-04-09 10:26:31.665715	13
312	546	CASH	2024-04-09 10:26:40.055403	2024-04-09 10:26:44.36214	13
313	546	CARD	2024-04-09 10:26:43.043976	2024-04-09 10:26:44.362148	13
314	548	CARD	2024-04-09 10:26:53.637106	2024-04-09 10:26:54.94913	13
315	551	CARD	2024-04-09 10:27:25.825285	2024-04-09 10:28:08.883672	13
316	553	CARD	2024-04-09 10:33:08.27078	2024-04-09 10:33:09.959658	13
317	555	CARD	2024-04-09 10:34:13.261295	2024-04-09 10:34:14.670742	13
318	557	CARD	2024-04-09 10:34:58.741089	2024-04-09 10:35:00.172633	13
319	559	CASH	2024-04-09 10:44:49.774324	2024-04-09 10:44:51.183989	13
320	563	CASH	2024-04-09 10:45:04.618479	2024-04-09 10:45:06.780071	13
321	567	CARD	2024-04-09 10:45:19.824999	2024-04-09 10:45:21.187069	13
322	569	CASH	2024-04-09 10:45:29.389144	2024-04-09 10:45:30.737844	13
323	571	CARD	2024-04-09 10:45:40.641388	2024-04-09 10:45:42.058869	13
324	575	CARD	2024-04-09 10:45:57.778458	2024-04-09 10:45:59.058674	13
325	580	CASH	2024-04-09 10:47:48.492722	2024-04-09 10:47:50.008631	13
326	584	CASH	2024-04-09 10:48:06.290681	2024-04-09 10:48:08.594113	13
327	586	CARD	2024-04-09 10:48:15.166911	2024-04-09 10:48:17.460905	13
328	588	CARD	2024-04-09 10:48:26.114041	2024-04-09 10:48:27.441037	13
329	590	CASH	2024-04-09 10:48:36.036554	2024-04-09 10:48:37.395923	13
330	592	CARD	2024-04-09 10:48:46.138554	2024-04-09 10:48:47.438854	13
331	594	CASH	2024-04-09 10:48:55.675304	2024-04-09 10:48:59.880596	13
332	594	CARD	2024-04-09 10:48:58.585816	2024-04-09 10:48:59.880584	13
333	596	CARD	2024-04-09 10:49:08.256236	2024-04-09 10:49:09.583537	13
334	599	CASH	2024-04-09 11:00:59.591923	2024-04-09 11:01:01.001655	13
335	603	CASH	2024-04-09 11:01:17.199594	2024-04-09 11:01:19.416	13
336	605	CARD	2024-04-09 11:01:24.588385	2024-04-09 11:01:26.879987	13
337	607	CARD	2024-04-09 11:01:34.708266	2024-04-09 11:01:36.007451	13
338	609	CASH	2024-04-09 11:01:44.576462	2024-04-09 11:01:45.942665	13
339	611	CARD	2024-04-09 11:01:54.839584	2024-04-09 11:01:56.161255	13
340	613	CASH	2024-04-09 11:02:04.230145	2024-04-09 11:02:08.48119	13
341	613	CARD	2024-04-09 11:02:07.096686	2024-04-09 11:02:08.481197	13
342	615	CARD	2024-04-09 11:02:16.945234	2024-04-09 11:02:18.269459	13
343	618	CASH	2024-04-09 11:11:46.548029	2024-04-09 11:11:48.081627	13
344	622	CASH	2024-04-09 11:12:07.872892	2024-04-09 11:12:10.053893	13
345	624	CARD	2024-04-09 11:12:32.924916	2024-04-09 11:12:35.444426	13
346	626	CARD	2024-04-09 11:12:43.448048	2024-04-09 11:12:45.124499	13
347	628	CASH	2024-04-09 11:12:54.150378	2024-04-09 11:12:55.456668	13
348	630	CARD	2024-04-09 11:13:04.148604	2024-04-09 11:13:05.572574	13
349	632	CASH	2024-04-09 11:13:13.899693	2024-04-09 11:13:18.386414	13
350	632	CARD	2024-04-09 11:13:16.990605	2024-04-09 11:13:18.386423	13
351	634	CARD	2024-04-09 11:13:26.600028	2024-04-09 11:13:27.977057	13
352	637	CASH	2024-04-09 11:35:54.965637	2024-04-09 11:35:56.496051	13
353	641	CASH	2024-04-09 11:36:12.721507	2024-04-09 11:36:14.841924	13
354	643	CARD	2024-04-09 11:36:19.795546	2024-04-09 11:36:22.086612	13
355	645	CARD	2024-04-09 11:36:29.930469	2024-04-09 11:36:31.350231	13
356	647	CASH	2024-04-09 11:36:40.184373	2024-04-09 11:36:41.560486	13
357	649	CARD	2024-04-09 11:36:50.534387	2024-04-09 11:36:51.910272	13
358	651	CASH	2024-04-09 11:37:00.402111	2024-04-09 11:37:04.934853	13
359	651	CARD	2024-04-09 11:37:03.435467	2024-04-09 11:37:04.934861	13
360	653	CARD	2024-04-09 11:37:13.365314	2024-04-09 11:37:14.842021	13
361	655	CARD	2024-04-09 11:39:04.22686	2024-04-09 11:39:05.682599	13
362	658	CASH	2024-04-09 11:41:21.694595	2024-04-09 11:41:22.242608	13
363	662	CASH	2024-04-09 11:41:29.191995	2024-04-09 11:41:30.039192	13
364	664	CARD	2024-04-09 11:41:32.249433	2024-04-09 11:41:33.223933	13
365	666	CARD	2024-04-09 11:41:36.628791	2024-04-09 11:41:37.163064	13
366	668	CASH	2024-04-09 11:41:40.819559	2024-04-09 11:41:41.373726	13
367	670	CARD	2024-04-09 11:41:45.090671	2024-04-09 11:41:45.613213	13
368	672	CASH	2024-04-09 11:41:49.142159	2024-04-09 11:41:50.806153	13
369	672	CARD	2024-04-09 11:41:50.265388	2024-04-09 11:41:50.806145	13
370	674	CARD	2024-04-09 11:41:54.323648	2024-04-09 11:41:54.841753	13
371	679	CASH	2024-04-09 12:03:34.597986	\N	\N
372	706	CASH	2024-04-09 12:07:59.105637	2024-04-09 12:08:00.576273	13
373	710	CASH	2024-04-09 12:08:16.475308	2024-04-09 12:08:18.590963	13
374	712	CARD	2024-04-09 12:08:23.666961	2024-04-09 12:08:25.875496	13
375	714	CARD	2024-04-09 12:08:34.098299	2024-04-09 12:08:35.558325	13
376	716	CASH	2024-04-09 12:08:44.531355	2024-04-09 12:08:46.031104	13
377	718	CARD	2024-04-09 12:08:55.071321	2024-04-09 12:08:56.42082	13
378	720	CASH	2024-04-09 12:09:04.87308	2024-04-09 12:09:09.350616	13
379	720	CARD	2024-04-09 12:09:08.002179	2024-04-09 12:09:09.350598	13
380	722	CARD	2024-04-09 12:09:19.067237	2024-04-09 12:09:20.611265	13
381	727	CASH	2024-04-09 12:12:31.465141	2024-04-09 12:12:32.898396	13
382	731	CASH	2024-04-09 12:12:48.718042	2024-04-09 12:12:50.931231	13
383	733	CARD	2024-04-09 12:12:56.571056	2024-04-09 12:12:58.911926	13
384	735	CARD	2024-04-09 12:13:07.04312	2024-04-09 12:13:08.493712	13
385	737	CASH	2024-04-09 12:13:17.909204	2024-04-09 12:13:19.407031	13
386	739	CARD	2024-04-09 12:13:29.165046	2024-04-09 12:13:30.60949	13
387	741	CASH	2024-04-09 12:13:39.752788	2024-04-09 12:13:44.076273	13
388	741	CARD	2024-04-09 12:13:42.659712	2024-04-09 12:13:44.076264	13
389	743	CARD	2024-04-09 12:13:52.994631	2024-04-09 12:13:54.507482	13
390	748	CASH	2024-04-09 12:18:11.230445	2024-04-09 12:18:11.849377	13
391	752	CASH	2024-04-09 12:18:19.297386	2024-04-09 12:18:20.192538	13
392	754	CARD	2024-04-09 12:18:22.53767	2024-04-09 12:18:23.596459	13
393	756	CARD	2024-04-09 12:18:27.184817	2024-04-09 12:18:27.741239	13
394	758	CASH	2024-04-09 12:18:31.630956	2024-04-09 12:18:32.192556	13
395	760	CARD	2024-04-09 12:18:36.134143	2024-04-09 12:18:36.701728	13
396	762	CASH	2024-04-09 12:18:40.457656	2024-04-09 12:18:42.276194	13
397	762	CARD	2024-04-09 12:18:41.723628	2024-04-09 12:18:42.276188	13
398	764	CARD	2024-04-09 12:18:45.957334	2024-04-09 12:18:46.506229	13
399	769	CASH	2024-04-09 12:19:55.609828	2024-04-09 12:19:56.287897	13
400	773	CASH	2024-04-09 12:20:04.913266	2024-04-09 12:20:05.97193	13
401	775	CARD	2024-04-09 12:20:08.637733	2024-04-09 12:20:09.802989	13
402	777	CARD	2024-04-09 12:20:13.897736	2024-04-09 12:20:14.545669	13
403	779	CASH	2024-04-09 12:20:18.90291	2024-04-09 12:20:19.549483	13
404	781	CARD	2024-04-09 12:20:24.094749	2024-04-09 12:20:24.739106	13
405	783	CASH	2024-04-09 12:20:28.870132	2024-04-09 12:20:30.92755	13
406	783	CARD	2024-04-09 12:20:30.27986	2024-04-09 12:20:30.927557	13
407	785	CARD	2024-04-09 12:20:35.09167	2024-04-09 12:20:35.741456	13
408	790	CASH	2024-04-10 02:26:11.087571	2024-04-10 02:26:11.679988	13
409	794	CASH	2024-04-10 02:26:19.15099	2024-04-10 02:26:20.03383	13
410	796	CARD	2024-04-10 02:26:22.386743	2024-04-10 02:26:23.424229	13
411	798	CARD	2024-04-10 02:26:27.090876	2024-04-10 02:26:27.640225	13
412	800	CASH	2024-04-10 02:26:31.479867	2024-04-10 02:26:32.033715	13
413	802	CARD	2024-04-10 02:26:35.963044	2024-04-10 02:26:36.549343	13
414	804	CASH	2024-04-10 02:26:40.306098	2024-04-10 02:26:42.024376	13
415	804	CARD	2024-04-10 02:26:41.483791	2024-04-10 02:26:42.024351	13
416	806	CARD	2024-04-10 02:26:45.865053	2024-04-10 02:26:46.405326	13
417	813	CASH	2024-04-10 10:56:37.615041	2024-04-10 10:56:38.180894	13
418	817	CASH	2024-04-10 10:56:45.236459	2024-04-10 10:56:46.076149	13
419	819	CARD	2024-04-10 10:56:48.372607	2024-04-10 10:56:49.409857	13
420	821	CARD	2024-04-10 10:56:52.875988	2024-04-10 10:56:53.404269	13
421	823	CASH	2024-04-10 10:56:57.124402	2024-04-10 10:56:57.657501	13
422	825	CARD	2024-04-10 10:57:01.46242	2024-04-10 10:57:02.010518	13
423	827	CASH	2024-04-10 10:57:05.717803	2024-04-10 10:57:07.400493	13
424	827	CARD	2024-04-10 10:57:06.870894	2024-04-10 10:57:07.400489	13
425	829	CARD	2024-04-10 10:57:10.967928	2024-04-10 10:57:11.511644	13
426	834	CASH	2024-04-10 11:00:09.14232	2024-04-10 11:00:09.722289	13
427	838	CASH	2024-04-10 11:00:17.194467	2024-04-10 11:00:18.090894	13
428	840	CARD	2024-04-10 11:00:20.475656	2024-04-10 11:00:21.567467	13
429	842	CARD	2024-04-10 11:00:25.311517	2024-04-10 11:00:25.881767	13
430	844	CASH	2024-04-10 11:00:29.826788	2024-04-10 11:00:30.401114	13
431	846	CARD	2024-04-10 11:00:34.364067	2024-04-10 11:00:34.921062	13
432	848	CASH	2024-04-10 11:00:38.623112	2024-04-10 11:00:40.381252	13
433	848	CARD	2024-04-10 11:00:39.820193	2024-04-10 11:00:40.381257	13
434	850	CARD	2024-04-10 11:00:44.250959	2024-04-10 11:00:44.800811	13
435	855	CASH	2024-04-10 11:01:23.34106	2024-04-10 11:01:23.924371	13
436	859	CASH	2024-04-10 11:01:31.410508	2024-04-10 11:01:32.284244	13
437	861	CARD	2024-04-10 11:01:34.527631	2024-04-10 11:01:35.57869	13
438	863	CARD	2024-04-10 11:01:39.169219	2024-04-10 11:01:39.725315	13
439	865	CASH	2024-04-10 11:01:43.562749	2024-04-10 11:01:44.113968	13
440	867	CARD	2024-04-10 11:01:48.03284	2024-04-10 11:01:48.591956	13
441	869	CASH	2024-04-10 11:01:52.202094	2024-04-10 11:01:53.926347	13
442	869	CARD	2024-04-10 11:01:53.370064	2024-04-10 11:01:53.926342	13
443	871	CARD	2024-04-10 11:01:57.519776	2024-04-10 11:01:58.064923	13
444	876	CASH	2024-04-10 11:06:00.959861	2024-04-10 11:06:01.643114	13
445	880	CASH	2024-04-10 11:06:09.816583	2024-04-10 11:06:10.838472	13
446	882	CARD	2024-04-10 11:06:13.466869	2024-04-10 11:06:14.641428	13
447	884	CARD	2024-04-10 11:06:18.643586	2024-04-10 11:06:19.273414	13
448	886	CASH	2024-04-10 11:06:23.583348	2024-04-10 11:06:24.229187	13
449	888	CARD	2024-04-10 11:06:28.717914	2024-04-10 11:06:29.348087	13
450	890	CASH	2024-04-10 11:06:33.72156	2024-04-10 11:06:35.734506	13
451	890	CARD	2024-04-10 11:06:35.115395	2024-04-10 11:06:35.73451	13
452	892	CARD	2024-04-10 11:06:39.837381	2024-04-10 11:06:40.500878	13
453	897	CASH	2024-04-10 11:08:31.866573	2024-04-10 11:08:32.526252	13
454	901	CASH	2024-04-10 11:08:40.636075	2024-04-10 11:08:41.637849	13
455	903	CARD	2024-04-10 11:08:44.200929	2024-04-10 11:08:45.358583	13
456	905	CARD	2024-04-10 11:08:49.345225	2024-04-10 11:08:49.993428	13
457	907	CASH	2024-04-10 11:08:54.221642	2024-04-10 11:08:54.859133	13
458	909	CARD	2024-04-10 11:08:59.407273	2024-04-10 11:09:00.045391	13
459	911	CASH	2024-04-10 11:09:04.375382	2024-04-10 11:09:06.379884	13
460	911	CARD	2024-04-10 11:09:05.734586	2024-04-10 11:09:06.379889	13
461	913	CARD	2024-04-10 11:09:10.494267	2024-04-10 11:09:11.123579	13
462	918	CASH	2024-04-10 11:12:31.787834	2024-04-10 11:12:32.684468	13
463	922	CASH	2024-04-10 11:12:43.505907	2024-04-10 11:12:44.91296	13
464	924	CARD	2024-04-10 11:12:48.465073	2024-04-10 11:12:50.122471	13
465	926	CARD	2024-04-10 11:12:55.648807	2024-04-10 11:12:56.617939	13
466	928	CASH	2024-04-10 11:13:02.481187	2024-04-10 11:13:03.37794	13
467	930	CARD	2024-04-10 11:13:09.423742	2024-04-10 11:13:10.310482	13
468	932	CASH	2024-04-10 11:13:15.931028	2024-04-10 11:13:18.756402	13
469	932	CARD	2024-04-10 11:13:17.86615	2024-04-10 11:13:18.756397	13
470	934	CARD	2024-04-10 11:13:24.491847	2024-04-10 11:13:25.375836	13
471	939	CASH	2024-04-10 11:19:25.612797	2024-04-10 11:19:26.560925	13
472	943	CASH	2024-04-10 11:19:37.628768	2024-04-10 11:19:38.89506	13
473	945	CARD	2024-04-10 11:19:42.248324	2024-04-10 11:19:43.742167	13
474	947	CARD	2024-04-10 11:19:48.914998	2024-04-10 11:19:49.705601	13
475	949	CASH	2024-04-10 11:19:55.007336	2024-04-10 11:19:55.820975	13
476	951	CARD	2024-04-10 11:20:01.192216	2024-04-10 11:20:01.98062	13
477	953	CASH	2024-04-10 11:20:07.160444	2024-04-10 11:20:09.537011	13
478	953	CARD	2024-04-10 11:20:08.792618	2024-04-10 11:20:09.537022	13
479	955	CARD	2024-04-10 11:20:14.430442	2024-04-10 11:20:15.166199	13
480	960	CASH	2024-04-12 18:36:26.845422	2024-04-12 18:36:27.849337	13
481	964	CASH	2024-04-12 18:36:38.866054	2024-04-12 18:36:40.089723	13
482	966	CARD	2024-04-12 18:36:43.335266	2024-04-12 18:36:44.767351	13
483	968	CARD	2024-04-12 18:36:49.876726	2024-04-12 18:36:50.672571	13
484	970	CASH	2024-04-12 18:36:56.006472	2024-04-12 18:36:56.804582	13
485	972	CARD	2024-04-12 18:37:02.281178	2024-04-12 18:37:03.046911	13
486	974	CASH	2024-04-12 18:37:08.008261	2024-04-12 18:37:10.412381	13
487	974	CARD	2024-04-12 18:37:09.647028	2024-04-12 18:37:10.412392	13
488	976	CARD	2024-04-12 18:37:15.410167	2024-04-12 18:37:16.240686	13
489	981	CARD	2024-04-14 23:33:45.878523	2024-04-14 23:33:49.334397	5
117	108	CARD	2024-03-14 12:57:26.507038	2024-04-14 23:37:54.423937	12
131	108	CASH	2024-03-25 22:27:41.179633	2024-04-14 23:37:54.423858	12
132	108	CASH	2024-03-25 22:27:41.282282	2024-04-14 23:37:54.423944	12
133	108	CARD	2024-03-25 22:45:02.034855	2024-04-14 23:37:54.423909	12
134	108	CASH	2024-03-25 22:45:10.143197	2024-04-14 23:37:54.423907	12
135	108	CARD	2024-03-25 22:45:17.021847	2024-04-14 23:37:54.423966	12
136	108	CASH	2024-03-25 23:01:37.786136	2024-04-14 23:37:54.423919	12
137	108	CARD	2024-03-26 00:11:25.346664	2024-04-14 23:37:54.42394	12
138	108	CASH	2024-03-26 00:21:54.906793	2024-04-14 23:37:54.423922	12
141	108	CASH	2024-04-02 21:32:41.350434	2024-04-14 23:37:54.423964	12
142	108	CARD	2024-04-02 21:56:05.556979	2024-04-14 23:37:54.423864	12
143	108	CASH	2024-04-02 21:56:13.910379	2024-04-14 23:37:54.423905	12
144	108	CASH	2024-04-03 10:25:59.209533	2024-04-14 23:37:54.423853	12
145	108	CARD	2024-04-03 10:26:10.608549	2024-04-14 23:37:54.423928	12
150	108	CARD	2024-04-03 16:39:25.220641	2024-04-14 23:37:54.42386	12
490	122	CARD	2024-04-15 22:37:09.771367	\N	\N
491	981	CARD	2024-04-18 19:40:29.813834	2024-04-18 20:20:58.682433	1
492	981	CARD	2024-04-18 19:40:54.719904	2024-04-18 20:20:58.682477	1
493	982	CASH	2024-04-22 15:27:14.977297	2024-04-22 15:27:15.58879	13
494	986	CASH	2024-04-22 15:27:23.538198	2024-04-22 15:27:24.436715	13
495	988	CARD	2024-04-22 15:27:26.779105	2024-04-22 15:27:27.892091	13
496	990	CARD	2024-04-22 15:27:31.624337	2024-04-22 15:27:32.195249	13
497	992	CASH	2024-04-22 15:27:36.295468	2024-04-22 15:27:36.854986	13
498	994	CARD	2024-04-22 15:27:41.014031	2024-04-22 15:27:41.574004	13
499	996	CASH	2024-04-22 15:27:45.336229	2024-04-22 15:27:47.098107	13
500	996	CARD	2024-04-22 15:27:46.535582	2024-04-22 15:27:47.098125	13
501	998	CARD	2024-04-22 15:27:50.89163	2024-04-22 15:27:51.454405	13
502	1003	CASH	2024-04-23 02:13:45.130846	2024-04-23 02:13:46.068557	13
503	1007	CASH	2024-04-23 02:13:57.021837	2024-04-23 02:13:58.2982	13
504	1009	CARD	2024-04-23 02:14:01.577547	2024-04-23 02:14:03.078323	13
505	1011	CARD	2024-04-23 02:14:08.188441	2024-04-23 02:14:08.949921	13
506	1013	CASH	2024-04-23 02:14:14.258935	2024-04-23 02:14:15.021462	13
507	1015	CARD	2024-04-23 02:14:20.388402	2024-04-23 02:14:21.180221	13
508	1017	CASH	2024-04-23 02:14:26.1914	2024-04-23 02:14:28.557318	13
509	1017	CARD	2024-04-23 02:14:27.803211	2024-04-23 02:14:28.557327	13
510	1019	CARD	2024-04-23 02:14:33.529309	2024-04-23 02:14:34.269979	13
511	1024	CASH	2024-04-23 18:16:06.150238	2024-04-23 18:16:07.302808	13
512	1028	CASH	2024-04-23 18:16:19.797687	2024-04-23 18:16:21.320532	13
513	1030	CARD	2024-04-23 18:16:25.177844	2024-04-23 18:16:26.951612	13
514	1032	CARD	2024-04-23 18:16:32.747986	2024-04-23 18:16:33.677502	13
515	1034	CASH	2024-04-23 18:16:39.819036	2024-04-23 18:16:40.753783	13
516	1036	CARD	2024-04-23 18:16:47.07767	2024-04-23 18:16:48.038352	13
517	1038	CASH	2024-04-23 18:16:53.982289	2024-04-23 18:16:56.951898	13
518	1038	CARD	2024-04-23 18:16:56.025249	2024-04-23 18:16:56.951888	13
519	1040	CARD	2024-04-23 18:17:02.958057	2024-04-23 18:17:03.888969	13
520	981	CARD	2024-04-23 18:55:44.434204	2024-04-23 18:55:49.457368	5
521	981	CARD	2024-04-23 18:55:51.913698	2024-04-23 18:55:57.940461	5
524	1045	CASH	2024-04-23 19:00:23.502796	2024-04-23 19:00:24.52178	13
526	1049	CASH	2024-04-23 19:00:35.818251	2024-04-23 19:00:37.090351	13
527	1051	CARD	2024-04-23 19:00:40.195445	2024-04-23 19:00:41.669601	13
528	1053	CARD	2024-04-23 19:00:46.628784	2024-04-23 19:00:47.365755	13
529	1055	CASH	2024-04-23 19:00:52.389511	2024-04-23 19:00:53.125524	13
530	1057	CARD	2024-04-23 19:00:58.327193	2024-04-23 19:00:59.074462	13
531	1059	CASH	2024-04-23 19:01:04.708798	2024-04-23 19:01:07.084953	13
532	1059	CARD	2024-04-23 19:01:06.324285	2024-04-23 19:01:07.08494	13
533	1061	CARD	2024-04-23 19:01:11.96477	2024-04-23 19:01:12.695935	13
522	981	CARD	2024-04-23 18:56:04.965984	2024-04-23 19:02:01.64997	1
523	981	CARD	2024-04-23 19:00:05.585352	2024-04-23 19:02:01.64998	1
525	981	CARD	2024-04-23 19:00:26.282233	2024-04-23 19:02:01.649981	1
535	1068	CASH	2024-06-16 07:21:12.322698	2024-06-16 07:21:13.392611	13
536	1072	CASH	2024-06-16 07:21:25.143325	2024-06-16 07:21:26.615454	13
537	1074	CARD	2024-06-16 07:21:30.553954	2024-06-16 07:21:32.364785	13
538	1076	CARD	2024-06-16 07:21:38.124685	2024-06-16 07:21:39.06105	13
539	1078	CASH	2024-06-16 07:21:45.409553	2024-06-16 07:21:46.347604	13
540	1080	CARD	2024-06-16 07:21:52.864701	2024-06-16 07:21:53.78623	13
541	1082	CASH	2024-06-16 07:21:59.737939	2024-06-16 07:22:02.7383	13
542	1082	CARD	2024-06-16 07:22:01.801709	2024-06-16 07:22:02.738308	13
543	1084	CARD	2024-06-16 07:22:08.656789	2024-06-16 07:22:09.590139	13
544	1089	CASH	2024-07-05 16:16:46.555146	2024-07-05 16:16:47.384469	13
545	1093	CASH	2024-07-05 16:16:56.964489	2024-07-05 16:16:57.996202	13
546	1095	CARD	2024-07-05 16:17:01.13839	2024-07-05 16:17:02.770819	13
547	1097	CARD	2024-07-05 16:17:07.353289	2024-07-05 16:17:08.026285	13
548	1099	CASH	2024-07-05 16:17:12.792424	2024-07-05 16:17:13.435133	13
549	1101	CARD	2024-07-05 16:17:18.468716	2024-07-05 16:17:19.110333	13
550	1103	CASH	2024-07-05 16:17:23.388536	2024-07-05 16:17:25.388677	13
551	1103	CARD	2024-07-05 16:17:24.759224	2024-07-05 16:17:25.388662	13
552	1105	CARD	2024-07-05 16:17:29.653845	2024-07-05 16:17:30.286361	13
534	981	CARD	2024-04-23 19:38:29.236442	2024-07-18 06:30:03.959197	1
553	1108	CASH	2024-07-18 19:28:32.181458	2024-07-18 19:28:33.909293	13
554	1112	CASH	2024-07-18 19:28:47.804183	2024-07-18 19:28:49.444196	13
555	1114	CARD	2024-07-18 19:28:53.516889	2024-07-18 19:28:55.350001	13
556	1116	CARD	2024-07-18 19:29:01.429921	2024-07-18 19:29:02.454351	13
557	1118	CASH	2024-07-18 19:29:08.954776	2024-07-18 19:29:09.936367	13
558	1120	CARD	2024-07-18 19:29:17.033744	2024-07-18 19:29:17.982511	13
559	1122	CASH	2024-07-18 19:29:24.209731	2024-07-18 19:29:27.281729	13
560	1122	CARD	2024-07-18 19:29:26.269214	2024-07-18 19:29:27.281741	13
561	1124	CARD	2024-07-18 19:29:33.636483	2024-07-18 19:29:34.673837	13
562	1129	CASH	2024-07-19 07:24:48.370376	2024-07-19 07:24:49.565348	13
563	1133	CASH	2024-07-19 07:25:02.623739	2024-07-19 07:25:04.077182	13
564	1135	CARD	2024-07-19 07:25:08.034785	2024-07-19 07:25:09.797512	13
565	1137	CARD	2024-07-19 07:25:15.318502	2024-07-19 07:25:16.12565	13
566	1139	CASH	2024-07-19 07:25:21.764712	2024-07-19 07:25:22.601624	13
567	1141	CARD	2024-07-19 07:25:28.475674	2024-07-19 07:25:29.306563	13
568	1143	CASH	2024-07-19 07:25:34.745082	2024-07-19 07:25:37.337661	13
569	1143	CARD	2024-07-19 07:25:36.528072	2024-07-19 07:25:37.337675	13
570	1145	CARD	2024-07-19 07:25:42.720651	2024-07-19 07:25:43.521502	13
571	1150	CASH	2024-08-01 14:29:31.241515	2024-08-01 14:29:31.965972	13
572	1154	CASH	2024-08-01 14:29:41.081968	2024-08-01 14:29:42.16455	13
573	1156	CARD	2024-08-01 14:29:44.979134	2024-08-01 14:29:46.290163	13
574	1158	CARD	2024-08-01 14:29:50.732717	2024-08-01 14:29:51.42714	13
575	1160	CASH	2024-08-01 14:29:56.144591	2024-08-01 14:29:56.840485	13
576	1162	CARD	2024-08-01 14:30:01.877232	2024-08-01 14:30:02.674023	13
577	1164	CASH	2024-08-01 14:30:07.5344	2024-08-01 14:30:09.779486	13
578	1164	CARD	2024-08-01 14:30:09.080673	2024-08-01 14:30:09.779501	13
579	1166	CARD	2024-08-01 14:30:14.358919	2024-08-01 14:30:15.057183	13
580	1173	CASH	2024-08-01 14:34:50.053606	2024-08-01 14:34:50.997983	13
581	1177	CASH	2024-08-01 14:35:01.926137	2024-08-01 14:35:03.421576	13
582	1179	CARD	2024-08-01 14:35:07.173229	2024-08-01 14:35:08.926547	13
583	1181	CARD	2024-08-01 14:35:14.561144	2024-08-01 14:35:15.49574	13
584	1183	CASH	2024-08-01 14:35:21.570754	2024-08-01 14:35:22.491403	13
585	1185	CARD	2024-08-01 14:35:28.745505	2024-08-01 14:35:29.649984	13
586	1187	CASH	2024-08-01 14:35:35.403086	2024-08-01 14:35:38.26757	13
587	1187	CARD	2024-08-01 14:35:37.360698	2024-08-01 14:35:38.267582	13
588	1189	CARD	2024-08-01 14:35:44.468072	2024-08-01 14:35:45.37487	13
589	1192	CASH	2024-08-01 14:39:56.310329	2024-08-01 14:39:57.015942	13
590	1196	CASH	2024-08-01 14:40:06.086243	2024-08-01 14:40:07.179599	13
591	1198	CARD	2024-08-01 14:40:09.969486	2024-08-01 14:40:11.226816	13
592	1200	CARD	2024-08-01 14:40:15.509584	2024-08-01 14:40:16.201422	13
593	1202	CASH	2024-08-01 14:40:20.676518	2024-08-01 14:40:21.333296	13
594	1204	CARD	2024-08-01 14:40:26.038307	2024-08-01 14:40:26.69637	13
595	1206	CASH	2024-08-01 14:40:31.142005	2024-08-01 14:40:33.200545	13
596	1206	CARD	2024-08-01 14:40:32.541468	2024-08-01 14:40:33.200533	13
597	1208	CARD	2024-08-01 14:40:37.469041	2024-08-01 14:40:38.147613	13
598	1213	CASH	2024-08-01 15:14:52.272823	2024-08-01 15:14:53.030198	13
599	1217	CASH	2024-08-01 15:15:02.549454	2024-08-01 15:15:03.721687	13
600	1219	CARD	2024-08-01 15:15:06.857704	2024-08-01 15:15:08.432026	13
601	1221	CARD	2024-08-01 15:15:13.067939	2024-08-01 15:15:13.830337	13
602	1223	CASH	2024-08-01 15:15:18.905817	2024-08-01 15:15:19.657426	13
603	1225	CARD	2024-08-01 15:15:24.763573	2024-08-01 15:15:25.498966	13
604	1227	CASH	2024-08-01 15:15:30.210414	2024-08-01 15:15:32.534358	13
605	1227	CARD	2024-08-01 15:15:31.777195	2024-08-01 15:15:32.534346	13
606	1229	CARD	2024-08-01 15:15:37.273853	2024-08-01 15:15:38.022578	13
607	1236	CARD	2024-08-19 10:21:57.987532	2024-08-19 10:21:59.384555	13
608	1238	CASH	2024-08-19 10:24:59.95795	2024-08-19 10:25:01.355876	13
609	1242	CASH	2024-08-19 10:25:16.676911	2024-08-19 10:25:18.762088	13
610	1244	CARD	2024-08-19 10:25:23.558444	2024-08-19 10:25:25.755099	13
611	1246	CARD	2024-08-19 10:25:33.308065	2024-08-19 10:25:34.56512	13
612	1248	CASH	2024-08-19 10:25:42.719072	2024-08-19 10:25:44.022115	13
613	1250	CARD	2024-08-19 10:25:52.403258	2024-08-19 10:25:53.662684	13
614	1252	CASH	2024-08-19 10:26:01.419178	2024-08-19 10:26:05.583568	13
615	1252	CARD	2024-08-19 10:26:04.212176	2024-08-19 10:26:05.583557	13
616	1254	CARD	2024-08-19 10:26:13.509412	2024-08-19 10:26:14.849744	13
617	1261	CASH	2024-08-19 10:28:26.949898	2024-08-19 10:28:27.645474	13
618	1265	CASH	2024-08-19 10:28:35.530399	2024-08-19 10:28:36.563936	13
619	1267	CARD	2024-08-19 10:28:39.269511	2024-08-19 10:28:40.512981	13
620	1269	CARD	2024-08-19 10:28:44.627998	2024-08-19 10:28:45.29105	13
621	1271	CASH	2024-08-19 10:28:49.79832	2024-08-19 10:28:50.452263	13
622	1273	CARD	2024-08-19 10:28:55.089926	2024-08-19 10:28:55.750148	13
623	1275	CASH	2024-08-19 10:29:00.061907	2024-08-19 10:29:02.171086	13
624	1275	CARD	2024-08-19 10:29:01.474686	2024-08-19 10:29:02.171096	13
625	1277	CARD	2024-08-19 10:29:06.486642	2024-08-19 10:29:07.137463	13
626	1282	CASH	2024-08-20 09:54:53.035854	2024-08-20 09:54:53.947901	13
627	1286	CASH	2024-08-20 09:55:04.554429	2024-08-20 09:55:05.983572	13
628	1288	CARD	2024-08-20 09:55:09.554426	2024-08-20 09:55:11.309014	13
629	1290	CARD	2024-08-20 09:55:16.950095	2024-08-20 09:55:17.863677	13
630	1292	CASH	2024-08-20 09:55:23.785432	2024-08-20 09:55:24.708666	13
631	1294	CARD	2024-08-20 09:55:30.825096	2024-08-20 09:55:31.752348	13
632	1296	CASH	2024-08-20 09:55:37.408396	2024-08-20 09:55:40.289268	13
633	1296	CARD	2024-08-20 09:55:39.367708	2024-08-20 09:55:40.289258	13
634	1298	CARD	2024-08-20 09:55:46.029488	2024-08-20 09:55:46.952913	13
635	1303	CASH	2024-08-20 15:09:05.727183	2024-08-20 15:09:06.319262	13
636	1307	CASH	2024-08-20 15:09:13.258565	2024-08-20 15:09:14.118891	13
637	1309	CARD	2024-08-20 15:09:16.380174	2024-08-20 15:09:17.448066	13
638	1311	CARD	2024-08-20 15:09:20.982656	2024-08-20 15:09:21.549095	13
639	1313	CASH	2024-08-20 15:09:25.36082	2024-08-20 15:09:25.91873	13
640	1315	CARD	2024-08-20 15:09:30.053211	2024-08-20 15:09:30.663868	13
641	1317	CASH	2024-08-20 15:09:34.355619	2024-08-20 15:09:36.114636	13
642	1317	CARD	2024-08-20 15:09:35.545449	2024-08-20 15:09:36.114645	13
643	1319	CARD	2024-08-20 15:09:39.857417	2024-08-20 15:09:40.426954	13
644	1324	CASH	2024-08-28 13:54:29.859448	2024-08-28 13:54:30.67165	13
645	1328	CASH	2024-08-28 13:54:39.082621	2024-08-28 13:54:40.139939	13
646	1330	CARD	2024-08-28 13:54:42.846736	2024-08-28 13:54:44.131519	13
647	1332	CARD	2024-08-28 13:54:48.382295	2024-08-28 13:54:49.060904	13
648	1334	CASH	2024-08-28 13:54:53.693263	2024-08-28 13:54:54.339885	13
649	1336	CARD	2024-08-28 13:54:59.232235	2024-08-28 13:54:59.89184	13
650	1338	CASH	2024-08-28 13:55:04.699369	2024-08-28 13:55:06.842268	13
651	1338	CARD	2024-08-28 13:55:06.169561	2024-08-28 13:55:06.842281	13
652	1340	CARD	2024-08-28 13:55:11.376535	2024-08-28 13:55:12.036593	13
653	1345	CASH	2024-08-28 17:04:25.788426	2024-08-28 17:04:26.544536	13
654	1349	CASH	2024-08-28 17:04:35.386648	2024-08-28 17:04:36.561119	13
655	1351	CARD	2024-08-28 17:04:39.504325	2024-08-28 17:04:40.870149	13
656	1353	CARD	2024-08-28 17:04:45.568464	2024-08-28 17:04:46.292216	13
657	1355	CASH	2024-08-28 17:04:51.346042	2024-08-28 17:04:52.063192	13
658	1357	CARD	2024-08-28 17:04:57.178904	2024-08-28 17:04:57.897165	13
659	1359	CASH	2024-08-28 17:05:02.794465	2024-08-28 17:05:05.15401	13
660	1359	CARD	2024-08-28 17:05:04.369077	2024-08-28 17:05:05.153999	13
661	1361	CARD	2024-08-28 17:05:10.009237	2024-08-28 17:05:10.753609	13
662	1366	CASH	2024-09-02 14:29:50.416613	2024-09-02 14:29:51.442544	13
663	1370	CASH	2024-09-02 14:30:03.554578	2024-09-02 14:30:04.948443	13
664	1372	CARD	2024-09-02 14:30:08.704061	2024-09-02 14:30:10.37406	13
665	1374	CARD	2024-09-02 14:30:16.006239	2024-09-02 14:30:16.838916	13
666	1376	CASH	2024-09-02 14:30:22.542031	2024-09-02 14:30:23.329562	13
667	1378	CARD	2024-09-02 14:30:29.163539	2024-09-02 14:30:30.001589	13
668	1380	CASH	2024-09-02 14:30:35.240549	2024-09-02 14:30:37.813535	13
669	1380	CARD	2024-09-02 14:30:36.965949	2024-09-02 14:30:37.81352	13
670	1382	CARD	2024-09-02 14:30:43.227184	2024-09-02 14:30:44.046405	13
671	1387	CASH	2024-09-04 19:34:21.143063	2024-09-04 19:34:21.787437	13
672	1391	CASH	2024-09-04 19:34:29.530989	2024-09-04 19:34:30.564378	13
673	1393	CARD	2024-09-04 19:34:33.195686	2024-09-04 19:34:34.397403	13
674	1395	CARD	2024-09-04 19:34:38.418293	2024-09-04 19:34:39.035625	13
675	1397	CASH	2024-09-04 19:34:43.70774	2024-09-04 19:34:44.326315	13
676	1399	CARD	2024-09-04 19:34:48.939372	2024-09-04 19:34:49.530802	13
677	1401	CASH	2024-09-04 19:34:53.736702	2024-09-04 19:34:55.608119	13
678	1401	CARD	2024-09-04 19:34:54.994189	2024-09-04 19:34:55.608154	13
679	1403	CARD	2024-09-04 19:34:59.681622	2024-09-04 19:35:00.283005	13
680	1408	CASH	2024-09-04 20:03:59.515868	2024-09-04 20:04:00.182701	13
681	1412	CASH	2024-09-04 20:04:08.03652	2024-09-04 20:04:08.94206	13
682	1414	CARD	2024-09-04 20:04:11.485923	2024-09-04 20:04:12.752641	13
683	1416	CARD	2024-09-04 20:04:16.841441	2024-09-04 20:04:17.434037	13
684	1418	CASH	2024-09-04 20:04:21.8587	2024-09-04 20:04:22.465894	13
685	1420	CARD	2024-09-04 20:04:26.811613	2024-09-04 20:04:27.389439	13
686	1422	CASH	2024-09-04 20:04:31.515393	2024-09-04 20:04:33.366407	13
687	1422	CARD	2024-09-04 20:04:32.776568	2024-09-04 20:04:33.366414	13
688	1424	CARD	2024-09-04 20:04:37.395456	2024-09-04 20:04:37.969161	13
689	1429	CASH	2024-09-08 11:46:46.84829	2024-09-08 11:46:47.830429	13
690	1433	CASH	2024-09-08 11:46:59.00105	2024-09-08 11:47:00.492088	13
691	1435	CARD	2024-09-08 11:47:04.324531	2024-09-08 11:47:06.001864	13
692	1437	CARD	2024-09-08 11:47:11.826182	2024-09-08 11:47:12.752652	13
693	1439	CASH	2024-09-08 11:47:19.322454	2024-09-08 11:47:20.2624	13
694	1441	CARD	2024-09-08 11:47:26.636517	2024-09-08 11:47:27.572098	13
695	1443	CASH	2024-09-08 11:47:33.526711	2024-09-08 11:47:36.448199	13
696	1443	CARD	2024-09-08 11:47:35.514079	2024-09-08 11:47:36.448208	13
697	1445	CARD	2024-09-08 11:47:42.457584	2024-09-08 11:47:43.384511	13
698	1450	CASH	2024-09-08 12:03:12.875337	2024-09-08 12:03:13.481134	13
699	1454	CASH	2024-09-08 12:03:20.7557	2024-09-08 12:03:21.682467	13
700	1456	CARD	2024-09-08 12:03:24.219401	2024-09-08 12:03:25.365354	13
701	1458	CARD	2024-09-08 12:03:29.196824	2024-09-08 12:03:29.779353	13
702	1460	CASH	2024-09-08 12:03:33.899528	2024-09-08 12:03:34.509196	13
703	1462	CARD	2024-09-08 12:03:39.029358	2024-09-08 12:03:39.668076	13
704	1464	CASH	2024-09-08 12:03:43.881416	2024-09-08 12:03:45.88226	13
705	1464	CARD	2024-09-08 12:03:45.236521	2024-09-08 12:03:45.882269	13
706	1466	CARD	2024-09-08 12:03:50.168093	2024-09-08 12:03:50.769082	13
707	1471	CASH	2024-09-08 12:07:36.472388	2024-09-08 12:07:37.434201	13
708	1475	CASH	2024-09-08 12:07:48.374626	2024-09-08 12:07:49.441892	13
709	1477	CARD	2024-09-08 12:07:52.732939	2024-09-08 12:07:54.197711	13
710	1479	CARD	2024-09-08 12:07:58.776198	2024-09-08 12:07:59.461533	13
711	1481	CASH	2024-09-08 12:08:04.660966	2024-09-08 12:08:05.320047	13
712	1483	CARD	2024-09-08 12:08:10.290471	2024-09-08 12:08:10.95261	13
713	1485	CASH	2024-09-08 12:08:15.897976	2024-09-08 12:08:18.000861	13
714	1485	CARD	2024-09-08 12:08:17.296106	2024-09-08 12:08:18.000845	13
715	1487	CARD	2024-09-08 12:08:22.407949	2024-09-08 12:08:23.036601	13
716	1492	CASH	2024-09-08 12:21:31.179849	2024-09-08 12:21:32.207657	13
717	1496	CASH	2024-09-08 12:21:44.244953	2024-09-08 12:21:45.799473	13
718	1498	CARD	2024-09-08 12:21:49.775407	2024-09-08 12:21:51.535358	13
719	1500	CARD	2024-09-08 12:21:57.55064	2024-09-08 12:21:58.502005	13
720	1502	CASH	2024-09-08 12:22:04.944718	2024-09-08 12:22:05.885249	13
721	1504	CARD	2024-09-08 12:22:12.527698	2024-09-08 12:22:13.463866	13
722	1506	CASH	2024-09-08 12:22:19.627974	2024-09-08 12:22:22.720878	13
723	1506	CARD	2024-09-08 12:22:21.745515	2024-09-08 12:22:22.720893	13
724	1508	CARD	2024-09-08 12:22:28.855105	2024-09-08 12:22:29.810706	13
725	1513	CASH	2024-09-15 17:05:07.522129	2024-09-15 17:05:08.172257	13
726	1517	CASH	2024-09-15 17:05:15.641677	2024-09-15 17:05:16.563913	13
727	1519	CARD	2024-09-15 17:05:19.0583	2024-09-15 17:05:20.198097	13
728	1521	CARD	2024-09-15 17:05:23.996312	2024-09-15 17:05:24.587806	13
729	1523	CASH	2024-09-15 17:05:28.886365	2024-09-15 17:05:29.469273	13
730	1525	CARD	2024-09-15 17:05:33.638486	2024-09-15 17:05:34.21711	13
731	1527	CASH	2024-09-15 17:05:38.116691	2024-09-15 17:05:39.897222	13
732	1527	CARD	2024-09-15 17:05:39.307484	2024-09-15 17:05:39.897206	13
733	1529	CARD	2024-09-15 17:05:43.666272	2024-09-15 17:05:44.284551	13
734	1534	CASH	2024-09-18 20:09:39.528695	2024-09-18 20:09:40.297974	13
735	1538	CASH	2024-09-18 20:09:49.732697	2024-09-18 20:09:50.927888	13
736	1540	CARD	2024-09-18 20:09:54.029002	2024-09-18 20:09:55.42006	13
737	1542	CARD	2024-09-18 20:10:00.3194	2024-09-18 20:10:01.135258	13
738	1544	CASH	2024-09-18 20:10:06.793727	2024-09-18 20:10:07.557724	13
739	1546	CARD	2024-09-18 20:10:13.169617	2024-09-18 20:10:13.920648	13
740	1548	CASH	2024-09-18 20:10:18.950252	2024-09-18 20:10:21.386626	13
741	1548	CARD	2024-09-18 20:10:20.618431	2024-09-18 20:10:21.386607	13
742	1550	CARD	2024-09-18 20:10:26.35756	2024-09-18 20:10:27.131923	13
743	1555	CASH	2024-09-18 20:11:09.84323	2024-09-18 20:11:10.488385	13
744	1559	CASH	2024-09-18 20:11:18.226871	2024-09-18 20:11:19.133501	13
745	1561	CARD	2024-09-18 20:11:21.702246	2024-09-18 20:11:22.889986	13
746	1563	CARD	2024-09-18 20:11:26.828943	2024-09-18 20:11:27.415246	13
747	1565	CASH	2024-09-18 20:11:31.766196	2024-09-18 20:11:32.363368	13
748	1567	CARD	2024-09-18 20:11:36.618538	2024-09-18 20:11:37.201709	13
749	1569	CASH	2024-09-18 20:11:41.209694	2024-09-18 20:11:43.121969	13
750	1569	CARD	2024-09-18 20:11:42.473368	2024-09-18 20:11:43.121954	13
751	1571	CARD	2024-09-18 20:11:47.122058	2024-09-18 20:11:47.72252	13
752	1574	CASH	2024-09-18 20:32:29.830183	2024-09-18 20:32:30.956484	13
753	1578	CASH	2024-09-18 20:32:42.657035	2024-09-18 20:32:44.153616	13
754	1580	CARD	2024-09-18 20:32:48.102104	2024-09-18 20:32:49.829503	13
755	1582	CARD	2024-09-18 20:32:55.648833	2024-09-18 20:32:56.574855	13
756	1584	CASH	2024-09-18 20:33:02.799664	2024-09-18 20:33:03.759305	13
757	1586	CARD	2024-09-18 20:33:10.274867	2024-09-18 20:33:11.234152	13
758	1588	CASH	2024-09-18 20:33:17.337511	2024-09-18 20:33:20.229161	13
759	1588	CARD	2024-09-18 20:33:19.295131	2024-09-18 20:33:20.229172	13
760	1590	CARD	2024-09-18 20:33:26.231944	2024-09-18 20:33:27.167129	13
761	1595	CASH	2024-09-19 17:58:43.011467	2024-09-19 17:58:43.717921	13
762	1599	CASH	2024-09-19 17:58:58.224944	2024-09-19 17:58:59.335634	13
763	1601	CARD	2024-09-19 17:59:02.296265	2024-09-19 17:59:04.116536	13
764	1603	CARD	2024-09-19 17:59:08.828611	2024-09-19 17:59:09.55506	13
765	1605	CASH	2024-09-19 17:59:14.490691	2024-09-19 17:59:15.228172	13
766	1607	CARD	2024-09-19 17:59:20.222941	2024-09-19 17:59:20.955791	13
767	1609	CASH	2024-09-19 17:59:25.688099	2024-09-19 17:59:27.905617	13
768	1609	CARD	2024-09-19 17:59:27.208613	2024-09-19 17:59:27.905625	13
769	1611	CARD	2024-09-19 17:59:33.181816	2024-09-19 17:59:33.886749	13
770	1616	CASH	2024-09-19 18:22:10.954705	2024-09-19 18:22:11.893972	13
771	1620	CASH	2024-09-19 18:22:23.173424	2024-09-19 18:22:24.605261	13
772	1622	CARD	2024-09-19 18:22:28.223222	2024-09-19 18:22:29.858733	13
773	1624	CARD	2024-09-19 18:22:35.730267	2024-09-19 18:22:36.65765	13
774	1626	CASH	2024-09-19 18:22:42.728412	2024-09-19 18:22:43.619695	13
775	1628	CARD	2024-09-19 18:22:49.767528	2024-09-19 18:22:50.662287	13
776	1630	CASH	2024-09-19 18:22:56.385932	2024-09-19 18:22:59.16762	13
777	1630	CARD	2024-09-19 18:22:58.273309	2024-09-19 18:22:59.167629	13
778	1632	CARD	2024-09-19 18:23:05.953961	2024-09-19 18:23:06.860793	13
779	1637	CASH	2024-09-19 18:35:25.003818	2024-09-19 18:35:25.91166	13
780	1641	CASH	2024-09-19 18:35:37.439193	2024-09-19 18:35:38.834949	13
781	1643	CARD	2024-09-19 18:35:42.341119	2024-09-19 18:35:43.949953	13
782	1645	CARD	2024-09-19 18:35:49.436378	2024-09-19 18:35:50.314266	13
783	1647	CASH	2024-09-19 18:35:56.193969	2024-09-19 18:35:57.074832	13
784	1649	CARD	2024-09-19 18:36:03.271162	2024-09-19 18:36:04.172989	13
785	1651	CASH	2024-09-19 18:36:09.842674	2024-09-19 18:36:12.601264	13
786	1651	CARD	2024-09-19 18:36:11.71732	2024-09-19 18:36:12.601273	13
787	1653	CARD	2024-09-19 18:36:18.152338	2024-09-19 18:36:19.016879	13
788	1658	CASH	2024-09-19 18:38:36.490409	2024-09-19 18:38:37.120023	13
789	1662	CASH	2024-09-19 18:38:45.384171	2024-09-19 18:38:46.295457	13
790	1664	CARD	2024-09-19 18:38:48.792204	2024-09-19 18:38:49.907736	13
791	1666	CARD	2024-09-19 18:38:53.747218	2024-09-19 18:38:54.33618	13
792	1668	CASH	2024-09-19 18:38:58.380348	2024-09-19 18:38:58.970261	13
793	1670	CARD	2024-09-19 18:39:03.84108	2024-09-19 18:39:04.432612	13
794	1672	CASH	2024-09-19 18:39:08.474034	2024-09-19 18:39:10.301317	13
795	1672	CARD	2024-09-19 18:39:09.729208	2024-09-19 18:39:10.301307	13
796	1674	CARD	2024-09-19 18:39:14.405455	2024-09-19 18:39:14.997032	13
797	1679	CASH	2024-09-20 11:45:19.233455	2024-09-20 11:45:19.850978	13
798	1683	CASH	2024-09-20 11:45:27.844117	2024-09-20 11:45:28.774286	13
799	1685	CARD	2024-09-20 11:45:31.42565	2024-09-20 11:45:32.631868	13
800	1687	CARD	2024-09-20 11:45:36.387237	2024-09-20 11:45:36.95735	13
801	1689	CASH	2024-09-20 11:45:41.306575	2024-09-20 11:45:41.89343	13
802	1691	CARD	2024-09-20 11:45:46.086633	2024-09-20 11:45:46.668595	13
803	1693	CASH	2024-09-20 11:45:50.582826	2024-09-20 11:45:52.343141	13
804	1693	CARD	2024-09-20 11:45:51.775838	2024-09-20 11:45:52.343155	13
805	1695	CARD	2024-09-20 11:45:56.160021	2024-09-20 11:45:56.756554	13
806	1700	CASH	2024-09-22 13:09:39.513929	2024-09-22 13:09:40.120801	13
807	1704	CASH	2024-09-22 13:09:47.998976	2024-09-22 13:09:48.900244	13
808	1706	CARD	2024-09-22 13:09:51.345707	2024-09-22 13:09:52.523264	13
809	1708	CARD	2024-09-22 13:09:56.341271	2024-09-22 13:09:56.900433	13
810	1710	CASH	2024-09-22 13:10:01.093996	2024-09-22 13:10:01.759703	13
811	1712	CARD	2024-09-22 13:10:06.739164	2024-09-22 13:10:07.331347	13
812	1714	CASH	2024-09-22 13:10:11.394498	2024-09-22 13:10:13.20103	13
813	1714	CARD	2024-09-22 13:10:12.62818	2024-09-22 13:10:13.201039	13
814	1716	CARD	2024-09-22 13:10:17.074855	2024-09-22 13:10:17.660814	13
815	1721	CASH	2024-10-07 15:34:31.41664	2024-10-07 15:34:32.053071	13
816	1725	CASH	2024-10-07 15:34:39.755128	2024-10-07 15:34:40.669157	13
817	1727	CARD	2024-10-07 15:34:43.033806	2024-10-07 15:34:44.148063	13
818	1729	CARD	2024-10-07 15:34:47.777584	2024-10-07 15:34:48.340481	13
819	1731	CASH	2024-10-07 15:34:52.225431	2024-10-07 15:34:52.786048	13
820	1733	CARD	2024-10-07 15:34:56.76009	2024-10-07 15:34:57.439815	13
821	1735	CASH	2024-10-07 15:35:01.173645	2024-10-07 15:35:03.251777	13
822	1735	CARD	2024-10-07 15:35:02.506952	2024-10-07 15:35:03.251768	13
823	1737	CARD	2024-10-07 15:35:07.382825	2024-10-07 15:35:07.97504	13
824	1744	CASH	2024-10-11 09:29:43.251806	2024-10-11 09:29:44.171493	13
825	1748	CASH	2024-10-11 09:29:54.593836	2024-10-11 09:29:55.994145	13
826	1750	CARD	2024-10-11 09:29:59.486572	2024-10-11 09:30:01.151231	13
827	1752	CARD	2024-10-11 09:30:07.45096	2024-10-11 09:30:08.381328	13
828	1754	CASH	2024-10-11 09:30:14.370673	2024-10-11 09:30:15.317997	13
829	1756	CARD	2024-10-11 09:30:21.485866	2024-10-11 09:30:22.411923	13
830	1758	CASH	2024-10-11 09:30:28.127419	2024-10-11 09:30:31.009359	13
831	1758	CARD	2024-10-11 09:30:30.07175	2024-10-11 09:30:31.009369	13
832	1760	CARD	2024-10-11 09:30:36.823332	2024-10-11 09:30:37.717086	13
833	1765	CASH	2024-10-14 13:15:52.942795	2024-10-14 13:15:53.908981	13
834	1769	CASH	2024-10-14 13:16:04.956847	2024-10-14 13:16:06.449758	13
835	1771	CARD	2024-10-14 13:16:10.104743	2024-10-14 13:16:11.849475	13
836	1773	CARD	2024-10-14 13:16:17.517674	2024-10-14 13:16:18.450521	13
837	1775	CASH	2024-10-14 13:16:24.766504	2024-10-14 13:16:25.679217	13
838	1777	CARD	2024-10-14 13:16:32.027549	2024-10-14 13:16:32.96254	13
839	1779	CASH	2024-10-14 13:16:38.996597	2024-10-14 13:16:41.902705	13
840	1779	CARD	2024-10-14 13:16:40.971532	2024-10-14 13:16:41.902698	13
841	1781	CARD	2024-10-14 13:16:47.797868	2024-10-14 13:16:48.710313	13
842	1786	CASH	2024-10-14 13:57:06.244742	2024-10-14 13:57:06.855542	13
843	1790	CASH	2024-10-14 13:57:14.261143	2024-10-14 13:57:15.154885	13
844	1792	CARD	2024-10-14 13:57:17.567067	2024-10-14 13:57:18.772275	13
845	1794	CARD	2024-10-14 13:57:22.804278	2024-10-14 13:57:23.403213	13
846	1796	CASH	2024-10-14 13:57:27.57577	2024-10-14 13:57:28.167736	13
847	1798	CARD	2024-10-14 13:57:32.502198	2024-10-14 13:57:33.087625	13
848	1800	CASH	2024-10-14 13:57:36.976211	2024-10-14 13:57:38.804423	13
849	1800	CARD	2024-10-14 13:57:38.19087	2024-10-14 13:57:38.80443	13
850	1802	CARD	2024-10-14 13:57:42.698728	2024-10-14 13:57:43.282983	13
851	1807	CASH	2024-10-14 13:59:19.880313	2024-10-14 13:59:20.481438	13
852	1811	CASH	2024-10-14 13:59:27.853229	2024-10-14 13:59:28.763589	13
853	1813	CARD	2024-10-14 13:59:31.140882	2024-10-14 13:59:32.288205	13
854	1815	CARD	2024-10-14 13:59:35.945008	2024-10-14 13:59:36.522478	13
855	1817	CASH	2024-10-14 13:59:40.565628	2024-10-14 13:59:41.158997	13
856	1819	CARD	2024-10-14 13:59:45.35179	2024-10-14 13:59:45.928395	13
857	1821	CASH	2024-10-14 13:59:49.779192	2024-10-14 13:59:51.570012	13
858	1821	CARD	2024-10-14 13:59:50.958198	2024-10-14 13:59:51.57002	13
859	1823	CARD	2024-10-14 13:59:55.593782	2024-10-14 13:59:56.182209	13
860	1826	CASH	2024-10-17 17:30:05.200537	2024-10-17 17:30:06.09008	13
861	1830	CASH	2024-10-17 17:30:16.632695	2024-10-17 17:30:17.731448	13
862	1832	CARD	2024-10-17 17:30:20.692747	2024-10-17 17:30:22.119369	13
863	1834	CARD	2024-10-17 17:30:26.348824	2024-10-17 17:30:26.9784	13
864	1836	CASH	2024-10-17 17:30:31.570826	2024-10-17 17:30:32.232387	13
865	1838	CARD	2024-10-17 17:30:36.977321	2024-10-17 17:30:37.646003	13
866	1840	CASH	2024-10-17 17:30:41.846513	2024-10-17 17:30:43.738809	13
867	1840	CARD	2024-10-17 17:30:43.138581	2024-10-17 17:30:43.738796	13
868	1842	CARD	2024-10-17 17:30:48.069958	2024-10-17 17:30:48.711726	13
869	1849	CASH	2024-10-17 17:31:15.862128	2024-10-17 17:31:16.837062	13
870	1853	CASH	2024-10-17 17:31:28.21026	2024-10-17 17:31:29.749603	13
871	1855	CARD	2024-10-17 17:31:33.645755	2024-10-17 17:31:35.451694	13
872	1857	CARD	2024-10-17 17:31:41.393383	2024-10-17 17:31:42.362708	13
873	1859	CASH	2024-10-17 17:31:48.726792	2024-10-17 17:31:49.70406	13
874	1861	CARD	2024-10-17 17:31:56.355625	2024-10-17 17:31:57.379083	13
875	1863	CASH	2024-10-17 17:32:03.57775	2024-10-17 17:32:06.66312	13
876	1863	CARD	2024-10-17 17:32:05.703146	2024-10-17 17:32:06.663127	13
877	1865	CARD	2024-10-17 17:32:12.757279	2024-10-17 17:32:13.698249	13
878	1870	CASH	2024-10-22 12:24:11.078583	2024-10-22 12:24:11.726078	13
879	1874	CASH	2024-10-22 12:24:19.477896	2024-10-22 12:24:20.349571	13
880	1876	CARD	2024-10-22 12:24:22.931032	2024-10-22 12:24:24.137127	13
881	1878	CARD	2024-10-22 12:24:28.143754	2024-10-22 12:24:28.735757	13
882	1880	CASH	2024-10-22 12:24:33.065859	2024-10-22 12:24:33.638303	13
883	1882	CARD	2024-10-22 12:24:37.957222	2024-10-22 12:24:38.546967	13
884	1884	CASH	2024-10-22 12:24:42.555205	2024-10-22 12:24:44.358659	13
885	1884	CARD	2024-10-22 12:24:43.764851	2024-10-22 12:24:44.358666	13
886	1886	CARD	2024-10-22 12:24:48.294221	2024-10-22 12:24:48.89329	13
887	1891	CASH	2024-10-22 12:43:35.350475	2024-10-22 12:43:35.972422	13
888	1895	CASH	2024-10-22 12:43:43.276015	2024-10-22 12:43:44.206471	13
889	1897	CARD	2024-10-22 12:43:46.653132	2024-10-22 12:43:47.78982	13
890	1899	CARD	2024-10-22 12:43:51.571829	2024-10-22 12:43:52.157958	13
891	1901	CASH	2024-10-22 12:43:56.305216	2024-10-22 12:43:56.906339	13
892	1903	CARD	2024-10-22 12:44:01.330382	2024-10-22 12:44:01.991097	13
893	1905	CASH	2024-10-22 12:44:06.219184	2024-10-22 12:44:08.108168	13
894	1905	CARD	2024-10-22 12:44:07.521239	2024-10-22 12:44:08.108177	13
895	1907	CARD	2024-10-22 12:44:12.138583	2024-10-22 12:44:12.848045	13
896	1912	CASH	2024-10-22 13:10:26.840885	2024-10-22 13:10:27.465317	13
897	1916	CASH	2024-10-22 13:10:34.805629	2024-10-22 13:10:35.728824	13
898	1918	CARD	2024-10-22 13:10:38.307128	2024-10-22 13:10:39.499871	13
899	1920	CARD	2024-10-22 13:10:43.641295	2024-10-22 13:10:44.241451	13
900	1922	CASH	2024-10-22 13:10:48.484858	2024-10-22 13:10:49.223809	13
901	1924	CARD	2024-10-22 13:10:53.714542	2024-10-22 13:10:54.338673	13
902	1926	CASH	2024-10-22 13:10:58.549554	2024-10-22 13:11:00.434547	13
903	1926	CARD	2024-10-22 13:10:59.798987	2024-10-22 13:11:00.434559	13
904	1928	CARD	2024-10-22 13:11:04.759561	2024-10-22 13:11:05.369383	13
905	1933	CASH	2024-10-22 13:16:03.190252	2024-10-22 13:16:04.150785	13
906	1937	CASH	2024-10-22 13:16:15.046372	2024-10-22 13:16:16.505811	13
907	1939	CARD	2024-10-22 13:16:20.166349	2024-10-22 13:16:21.861399	13
908	1941	CARD	2024-10-22 13:16:27.664569	2024-10-22 13:16:28.615828	13
909	1943	CASH	2024-10-22 13:16:34.673112	2024-10-22 13:16:35.598505	13
910	1945	CARD	2024-10-22 13:16:41.824663	2024-10-22 13:16:42.749617	13
911	1947	CASH	2024-10-22 13:16:48.689315	2024-10-22 13:16:51.549026	13
912	1947	CARD	2024-10-22 13:16:50.638713	2024-10-22 13:16:51.54902	13
913	1949	CARD	2024-10-22 13:16:57.443291	2024-10-22 13:16:58.382755	13
914	1954	CASH	2024-10-22 13:18:22.619261	2024-10-22 13:18:23.323772	13
915	1958	CASH	2024-10-22 13:18:31.66528	2024-10-22 13:18:32.704898	13
916	1960	CARD	2024-10-22 13:18:35.513561	2024-10-22 13:18:36.80783	13
917	1962	CARD	2024-10-22 13:18:41.030596	2024-10-22 13:18:41.714089	13
918	1964	CASH	2024-10-22 13:18:46.315172	2024-10-22 13:18:47.006054	13
919	1966	CARD	2024-10-22 13:18:51.667436	2024-10-22 13:18:52.349729	13
920	1968	CASH	2024-10-22 13:18:56.664027	2024-10-22 13:18:58.78869	13
921	1968	CARD	2024-10-22 13:18:58.078011	2024-10-22 13:18:58.788684	13
922	1970	CARD	2024-10-22 13:19:03.248714	2024-10-22 13:19:03.919065	13
923	1975	CASH	2024-10-22 13:22:45.472236	2024-10-22 13:22:46.432964	13
924	1979	CASH	2024-10-22 13:22:57.167487	2024-10-22 13:22:58.600534	13
925	1981	CARD	2024-10-22 13:23:02.350841	2024-10-22 13:23:04.110595	13
926	1983	CARD	2024-10-22 13:23:09.754912	2024-10-22 13:23:10.691744	13
927	1985	CASH	2024-10-22 13:23:16.985738	2024-10-22 13:23:17.915759	13
928	1987	CARD	2024-10-22 13:23:24.209699	2024-10-22 13:23:25.13317	13
929	1989	CASH	2024-10-22 13:23:30.981428	2024-10-22 13:23:33.886717	13
930	1989	CARD	2024-10-22 13:23:32.948492	2024-10-22 13:23:33.886711	13
931	1991	CARD	2024-10-22 13:23:39.76159	2024-10-22 13:23:40.704177	13
932	1996	CASH	2024-10-22 18:35:04.792156	2024-10-22 18:35:05.47969	13
933	2000	CASH	2024-10-22 18:35:13.338596	2024-10-22 18:35:14.295214	13
934	2002	CARD	2024-10-22 18:35:16.776783	2024-10-22 18:35:17.929382	13
935	2004	CARD	2024-10-22 18:35:21.856953	2024-10-22 18:35:22.470072	13
936	2006	CASH	2024-10-22 18:35:26.689842	2024-10-22 18:35:27.29434	13
937	2008	CARD	2024-10-22 18:35:31.621254	2024-10-22 18:35:32.248203	13
938	2010	CASH	2024-10-22 18:35:36.264208	2024-10-22 18:35:38.116172	13
939	2010	CARD	2024-10-22 18:35:37.506907	2024-10-22 18:35:38.116166	13
940	2012	CARD	2024-10-22 18:35:42.072058	2024-10-22 18:35:42.659023	13
941	2017	CASH	2024-10-22 18:37:01.757496	2024-10-22 18:37:02.777707	13
942	2021	CASH	2024-10-22 18:37:14.03361	2024-10-22 18:37:15.519087	13
943	2023	CARD	2024-10-22 18:37:19.259558	2024-10-22 18:37:20.993595	13
944	2025	CARD	2024-10-22 18:37:26.848474	2024-10-22 18:37:27.785474	13
945	2027	CASH	2024-10-22 18:37:34.21283	2024-10-22 18:37:35.148911	13
946	2029	CARD	2024-10-22 18:37:41.456349	2024-10-22 18:37:42.391573	13
947	2031	CASH	2024-10-22 18:37:48.247717	2024-10-22 18:37:51.13197	13
948	2031	CARD	2024-10-22 18:37:50.207303	2024-10-22 18:37:51.131979	13
949	2033	CARD	2024-10-22 18:37:57.03057	2024-10-22 18:37:57.957521	13
950	2038	CASH	2024-10-22 18:38:42.631946	2024-10-22 18:38:43.240871	13
951	2042	CASH	2024-10-22 18:38:50.834918	2024-10-22 18:38:51.727218	13
952	2044	CARD	2024-10-22 18:38:54.157122	2024-10-22 18:38:55.345079	13
953	2046	CARD	2024-10-22 18:38:59.136773	2024-10-22 18:38:59.73097	13
954	2048	CASH	2024-10-22 18:39:04.245369	2024-10-22 18:39:04.845069	13
955	2050	CARD	2024-10-22 18:39:09.099499	2024-10-22 18:39:09.6854	13
956	2052	CASH	2024-10-22 18:39:13.540316	2024-10-22 18:39:15.360726	13
957	2052	CARD	2024-10-22 18:39:14.762215	2024-10-22 18:39:15.360719	13
958	2054	CARD	2024-10-22 18:39:19.216214	2024-10-22 18:39:19.791671	13
959	2059	CASH	2024-10-27 12:06:31.878914	2024-10-27 12:06:32.821915	13
960	2063	CASH	2024-10-27 12:06:43.464203	2024-10-27 12:06:44.881849	13
961	2065	CARD	2024-10-27 12:06:48.468515	2024-10-27 12:06:50.128377	13
962	2067	CARD	2024-10-27 12:06:55.707178	2024-10-27 12:06:56.622089	13
963	2069	CASH	2024-10-27 12:07:02.683476	2024-10-27 12:07:03.611647	13
964	2071	CARD	2024-10-27 12:07:09.782306	2024-10-27 12:07:10.692749	13
965	2073	CASH	2024-10-27 12:07:16.48316	2024-10-27 12:07:19.402657	13
966	2073	CARD	2024-10-27 12:07:18.476621	2024-10-27 12:07:19.402663	13
967	2075	CARD	2024-10-27 12:07:25.353423	2024-10-27 12:07:26.263361	13
968	2080	CASH	2024-10-27 12:21:43.915713	2024-10-27 12:21:44.613613	13
969	2084	CASH	2024-10-27 12:21:52.638851	2024-10-27 12:21:53.696068	13
970	2086	CARD	2024-10-27 12:21:56.370252	2024-10-27 12:21:57.617158	13
971	2088	CARD	2024-10-27 12:22:01.786392	2024-10-27 12:22:02.460578	13
972	2090	CASH	2024-10-27 12:22:07.019398	2024-10-27 12:22:07.702605	13
973	2092	CARD	2024-10-27 12:22:12.267402	2024-10-27 12:22:12.939765	13
974	2094	CASH	2024-10-27 12:22:17.270352	2024-10-27 12:22:19.322273	13
975	2094	CARD	2024-10-27 12:22:18.647389	2024-10-27 12:22:19.322267	13
976	2096	CARD	2024-10-27 12:22:23.574665	2024-10-27 12:22:24.224858	13
977	2111	CASH	2024-10-29 12:09:48.985681	2024-10-29 12:09:49.933545	13
978	2115	CASH	2024-10-29 12:10:00.763304	2024-10-29 12:10:02.312502	13
979	2117	CARD	2024-10-29 12:10:06.637648	2024-10-29 12:10:08.394688	13
980	2119	CARD	2024-10-29 12:10:14.152943	2024-10-29 12:10:15.101322	13
981	2121	CASH	2024-10-29 12:10:21.214266	2024-10-29 12:10:22.142133	13
982	2123	CARD	2024-10-29 12:10:28.544765	2024-10-29 12:10:29.460248	13
983	2125	CASH	2024-10-29 12:10:35.352095	2024-10-29 12:10:38.244699	13
984	2125	CARD	2024-10-29 12:10:37.320413	2024-10-29 12:10:38.244706	13
985	2127	CARD	2024-10-29 12:10:44.116345	2024-10-29 12:10:45.052428	13
986	2132	CASH	2024-10-30 18:22:20.775142	2024-10-30 18:22:21.368526	13
987	2136	CASH	2024-10-30 18:22:28.665123	2024-10-30 18:22:29.610875	13
988	2138	CARD	2024-10-30 18:22:32.048456	2024-10-30 18:22:33.211235	13
989	2140	CARD	2024-10-30 18:22:36.869742	2024-10-30 18:22:37.462498	13
990	2142	CASH	2024-10-30 18:22:41.465789	2024-10-30 18:22:42.038457	13
991	2144	CARD	2024-10-30 18:22:46.146568	2024-10-30 18:22:46.708772	13
992	2146	CASH	2024-10-30 18:22:50.463686	2024-10-30 18:22:52.211184	13
993	2146	CARD	2024-10-30 18:22:51.638099	2024-10-30 18:22:52.211192	13
994	2148	CARD	2024-10-30 18:22:56.056826	2024-10-30 18:22:56.633322	13
\.


--
-- Data for Name: t_table; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_table (id, number, branch_id, uuid) FROM stdin;
2	2	1	cb332cb4-6595-49ff-acdd-eac0a3eea425
3	3	1	6ea52ff0-7d94-4880-8dbf-abf4513b51a0
4	4	1	709878e3-af34-4469-9d1a-470ee9482662
5	5	1	4f08aa84-0f13-455d-8358-96bad957cbc6
6	6	1	e33c1d70-f2c1-4fb7-971c-cd954310f63a
7	7	1	140222a4-41db-4286-93e4-ff7ab233eb64
8	8	1	7aafb159-99aa-4f09-905c-3ff295458c03
9	9	1	d948a756-95ee-45a0-a58f-7c05d00eacbf
27	1	3	ca0b0e1a-5f79-44ed-8abf-f0c03f3000ce
28	2	3	893ee9a4-0964-4de6-9a01-d29fce789fb4
12	2	2	e9f85f6e-3fe2-4d9b-b93d-1ba4121082d1
13	3	2	8640f1e4-ef92-4c52-b672-9885d8c51622
14	4	2	3b6bfaac-ada2-44a0-991b-cd9aeb701700
15	5	2	8e1a62c0-1121-4975-9de2-6bba08dde4ce
16	6	2	caf188b8-f4b9-452e-bd3e-f049356c6c92
17	7	2	a36bd884-a47b-4b43-9257-c83f94640e5a
18	8	2	264319e6-fb9c-4ca5-bf0b-973472e51c42
19	9	2	dbfd2a39-45fe-4f64-b415-4ef2bb275115
20	10	2	4a0a57f1-da80-406d-8c08-ec6ba4d6658c
21	11	2	2199e5b6-3115-4055-b4bb-4bd3a862958d
22	12	2	1fa68caf-f3a4-45b0-8f8c-370c4f4de0ff
23	13	2	305cb915-d074-4eac-a184-5fbbe1396ac5
29	3	3	f825d27b-e69b-46d8-b772-28b24f22716c
30	4	3	96cdd485-30e6-4688-a52f-67d963ce0491
31	5	3	77e12c86-12c7-430a-bd24-7c85707d0287
32	6	3	5c76b4b6-0f5d-4b0f-ab3b-6971eab1412d
33	7	3	8371f262-0dbc-4576-8af7-23303478162b
34	8	3	d48c6852-0160-4aed-becf-c4ada22be366
35	9	3	38487036-3186-4f32-add8-f75e891f864f
36	10	3	17331837-4435-44da-b860-ab170bd64a2b
37	11	3	53df007e-f2cf-4350-8d20-7cd19ef63d8b
38	12	3	b76a2cd4-3b7b-4ebf-85b1-bc10f427de4b
39	13	3	0acacc79-8da4-425c-ab1c-49e81d27a487
40	14	3	a99b3b1b-2ace-4630-8948-1a676d0412b9
41	15	3	eeed8a37-ae28-4f5e-99ea-7155f9623319
42	1	6	7630d215-c641-40bb-9eaf-ea9a812a3392
11	1	2	4d447290-817a-4e47-ae3f-94f2b1900353
43	2	6	b9ffa783-bc8a-4bbd-beec-30b5fe2c0268
44	3	6	b7be21b3-0fd4-4fe6-ac31-683a98749226
45	4	6	f853decd-52d9-4abe-86be-59d2bcd7791b
46	5	6	e203e51d-31b5-4dac-8a3a-b3f88180603e
47	6	6	94ff3974-118e-43eb-a257-7fdd3d9f40dd
48	7	6	7fe11766-9634-4ab0-8ce1-85cafc88397a
49	8	6	22f3f70a-412f-48bd-8834-dfae4ad59bdf
50	9	6	d42bffe3-b050-49f7-8d2d-e6a7640805d7
51	10	6	0612dbe8-a56a-48d6-9720-254f99c2baba
10	10	1	9ed0f481-403f-4fe5-b2f4-8585a53c38ff
1	1	1	4174ea2b-dad0-43bc-bf57-535f7b2a1f46
25	15	2	98265179-70b6-49c9-b613-439382e51b36
24	14	2	aa837373-8c1d-49fb-a731-7fcf999da391
\.


--
-- Data for Name: t_table_session; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_table_session (id, table_id, closed_at, table_session_uuid) FROM stdin;
5	6	\N	738f7414-f5d0-423a-92ce-c9c2f6b5bad5
10	13	\N	75b0c6a5-430b-42fc-8b93-4bf5aa342048
11	14	\N	adafa9a2-5235-4946-94f4-eb5c36ca3307
12	15	\N	38f0ec61-865a-4d0b-b666-89c39b2c34cd
13	16	\N	725a7e88-4a6f-4de1-a39e-d1e77e3f67d4
14	17	\N	678d57d4-2d11-40b4-a61d-d1d3a2a471fd
15	18	\N	fd12d01c-b9ca-4f21-a9ba-5d6c13f04927
16	19	\N	d280ce31-a993-4a57-9ed6-48d691f06f17
17	20	\N	302c1d1e-96aa-4b35-9321-ed0b5ca42e8e
18	21	\N	bf684e68-1da6-42ec-86e3-bca11b153ca7
19	22	\N	84324eb5-f355-4f2c-aa0f-6e55d0123435
20	23	\N	6a601cd5-9384-4b15-a80a-9f1a9a4097df
21	11	\N	ccccc188-618f-41ba-b138-48b0bbf29f45
22	10	\N	9f5a2e0b-cb4f-4756-b0e8-00ceec11160f
24	25	\N	701d31ca-94d4-479e-861f-6eeb2ad469bd
25	24	\N	984afe09-108a-4222-a719-3b6d1a0da3bc
8	9	2023-08-28 18:13:52.378853	1dc45d15-d375-4727-a25d-b19e75ee0c68
23	1	2023-08-31 13:19:11.910961	61e5fabc-8945-4566-ac01-1d6db85a42e3
1	2	2023-08-31 13:24:42.03169	cd7859de-633e-4914-a04b-ef13ba8dca23
28	2	2023-09-01 15:26:17.205409	23834bc3-ab97-42e6-87ba-3c089c9905b0
27	1	2023-09-06 17:01:34.45858	677888ac-7b74-4fa3-9680-95fc0ff61a78
31	5	\N	dd1fe228-c81b-4746-9f91-66188044cdc7
4	5	2023-09-19 22:47:19.216075	402336c4-7727-4ace-a568-76b755f8f358
2	3	2023-10-24 10:43:54.208573	534efb21-c7e1-4ec7-9359-3fc6e4ec9277
32	3	2023-10-24 10:43:58.189836	ad89e221-d926-4ebc-9937-795f39048043
33	3	2023-10-24 10:44:03.776829	7a5deff0-2195-4772-a1e4-16c10803b6d1
34	3	2023-10-24 10:44:49.818172	3dce39db-11f1-4dd8-8311-ecebf1850b35
35	3	2023-10-24 10:44:52.830635	01bdc8a8-2ef0-4a44-94da-9325fb781400
3	4	2023-10-24 10:47:18.814093	b269b872-ede1-4cb9-8753-b1abfa2231b3
36	3	2023-10-28 18:11:14.935841	b85c361b-bb79-4d2e-a273-e12f94d0bd83
26	9	2023-11-01 00:12:51.511753	c7bdca72-0712-4af5-b42c-2d63769ae4e0
7	8	2023-11-01 00:14:03.478527	67e8b6bf-e5d1-47b8-a4f0-690774450564
40	8	2023-11-01 00:14:15.635885	573d5b16-30d7-4521-9887-5e844c92ba23
41	8	2023-11-01 00:15:52.779821	20ec91b2-6c0d-48f2-a6c2-f0a29b7cfcc3
42	8	2023-11-01 00:16:13.470977	6fea667f-29e2-4b39-8f91-c39dbc2c2eb2
44	8	\N	754a7a7d-2f91-42be-bfea-5f369a5d9270
43	8	2023-11-01 00:17:56.280989	7836ca65-837a-4c38-9970-d930902d5154
29	2	2023-11-04 14:25:35.404845	d865f900-0947-4f15-89f4-6c1e4bbdbe65
45	2	2023-11-18 17:01:35.959091	e4c0b329-851d-42f1-bebe-696250c196a4
46	2	2023-11-18 17:28:27.413579	540cc8dd-7e49-4369-9846-1ee5cf55af29
47	2	2023-11-18 17:28:43.919437	71b602a0-7b52-4455-877d-566b61d24d56
48	2	2023-11-18 17:46:46.346986	61ad66b2-0a79-4aa8-a073-30b007541daa
38	3	2023-11-19 19:46:03.916822	a058a1f9-ae57-489e-8328-8643e19975af
30	1	2023-11-19 21:14:19.460522	e1a2a1b0-62cf-4d00-81a5-e7b6d19c8374
51	1	2023-11-19 21:14:49.475994	6dd416f9-b7cf-4d98-adfe-16d278b98551
52	1	2023-11-19 21:15:12.252338	354d2674-8beb-4189-825b-b54bfc4e9a4e
53	1	2023-11-19 21:16:15.098788	e082b4fc-9525-4a18-b836-e3dee28cbe31
54	1	2023-11-19 21:16:31.833718	69eb410a-c70e-49e2-b2c7-076d68daad23
55	1	2023-11-19 21:16:40.510125	005d1e82-d136-4faa-8e89-b28174ed030e
56	1	2023-11-19 21:16:46.253664	c9187c01-af75-41ad-871e-c2eebf15e0ef
49	2	2023-11-19 21:20:22.043812	e9410938-078d-4976-8da8-0a3d5367fc7a
58	2	2023-11-19 21:24:26.635379	de9d680e-5e7e-45b6-943a-746adfa28b63
50	3	2023-11-28 11:12:51.911837	efa23608-3fd6-48eb-ac86-c76ae29fb253
60	3	2023-11-30 17:36:06.969939	163eb234-664e-4643-8c7b-50143b5a33a0
61	3	2023-11-30 17:36:21.391515	9fa01e91-5eac-4bf8-924c-b85d629bda4d
62	3	2023-11-30 17:36:25.307118	d001d639-74b1-4198-8bbd-ea2e63c6ca87
63	3	2023-11-30 17:36:27.253904	f2cb6dc7-fa07-4899-8af8-b6f83a4ac835
64	3	2023-11-30 17:36:36.338155	7f77ee87-b20e-4ebd-b966-d2808eb4962f
65	3	2023-11-30 17:37:20.090927	7bd6bec7-4a66-41b6-a49d-d38e7859ebfd
66	3	2023-11-30 17:37:23.433677	60ef8368-c1ca-4518-8603-704dddfab5b3
67	3	2023-11-30 17:37:40.58125	053ea1c9-7485-4679-8925-9e28c94232cf
68	3	2023-11-30 17:37:58.676265	72a90396-07c7-44c0-8c35-f54ef7f8e0c1
69	3	2023-11-30 17:38:09.51543	1b33c68d-6004-4b74-99f4-ced3a6ff636f
70	3	2023-11-30 17:38:19.818934	99a48c09-d09f-413f-bc9a-92af3d2a10c7
71	3	2023-11-30 17:38:26.935765	4977ff72-88b0-42a0-95ba-91b6d53d7446
72	3	2023-11-30 17:38:32.141983	ea599d4f-88e9-47f4-8f7e-fb9cb36d4f44
57	1	2023-11-30 17:41:46.858553	1f0c5924-77a2-46fe-b170-8ed3527a1a0f
6	7	2023-11-30 17:42:14.312997	6d7dbf4c-d393-4955-8589-023a9d490a7e
73	3	2023-11-30 17:45:31.057233	651e29e4-646b-4abe-a11f-1b43e33aa89d
75	7	2023-11-30 18:50:47.203792	616aba95-db68-4668-89c6-8d606550aed9
39	9	2023-12-01 08:50:05.445841	a7a5473b-d36a-4056-9e72-69888f1592c4
79	9	\N	46ffd468-6129-480e-9a9a-aa0e8522768b
78	9	2023-12-01 08:50:10.123124	1837b744-ed4a-4af2-94a9-c2020e0c7cdd
59	2	2023-12-05 21:18:47.506704	f61191a2-82ca-4f57-a7b0-01f80db6c9d3
80	2	2023-12-06 18:19:37.898235	b17a4085-f175-4e69-98c2-77bfd033aafd
81	2	2023-12-12 19:10:57.812	d5e14de3-7e34-4f13-84ad-134c7b1c3326
76	3	2023-12-12 19:11:58.275073	c9c15226-a66a-4bff-a458-33aabd7f56a1
37	4	2023-12-12 19:13:11.709821	3ace4494-d8c6-44e6-b3cd-4ca771fa2d68
84	4	2023-12-12 19:16:03.505864	ee269389-5c76-4c6d-8fbf-d90cb13bd3fb
85	4	2023-12-12 19:32:27.485874	cc463c29-d945-49b8-bac6-5018e2fb4420
86	4	2023-12-12 19:32:31.076435	5195b4d2-5f4a-4fac-85b3-a9a44b656b84
87	4	2023-12-12 19:32:56.416547	10faacf4-6378-4ae0-82f1-4cc397670d61
88	4	2023-12-12 20:03:47.911673	b0e855de-dd4a-43ef-8b8b-be8a688cc26f
89	4	2023-12-12 20:06:32.119676	48844524-8b69-46fd-9b04-e2c3a06acdb7
90	4	2023-12-12 20:08:42.948487	19ed0c7b-acd0-4d98-a8bd-e2669ebcbff5
91	4	2023-12-12 20:08:45.63996	339e3c80-2aad-4e69-94b6-2e7ed7e3be28
92	4	2023-12-20 08:24:19.602386	af038b42-af0f-43fe-91bb-466cdc0552de
74	1	2023-12-23 08:29:32.649416	b249518c-67d5-4b89-a296-792388ae9f20
94	1	2023-12-23 08:29:49.2818	7909ec1e-e0bc-48c5-a876-f9fad3b69b28
95	1	2023-12-23 08:29:59.704283	4e0f31a6-ffee-4fa3-9631-dad191b95b9d
96	1	2023-12-23 08:31:35.468494	e3d8c917-6a9e-4b70-bb51-9776579b46e9
97	1	2023-12-23 08:38:35.829125	f305f8ff-bc85-4abe-be2f-be4a42eb9d47
98	1	2023-12-23 08:38:51.699863	e252e817-a247-4df5-90ff-6f3ed80f9854
99	1	2023-12-23 08:38:54.520181	0fc86c4e-3126-4ba9-a8bd-b447dd3d0915
101	7	\N	daeb2a32-3459-43c4-83f4-8c1b89655854
77	7	2023-12-23 08:39:48.745648	0383cfc5-4707-4687-817e-c554dea8a2ce
102	3	\N	3c3ee8d7-0c66-4bd3-8294-0b9ccd2bb657
83	3	2023-12-25 10:24:18.107849	be96e48b-e7a4-432e-91cf-de07960a5f5b
103	4	\N	a9d7cf84-90ec-4ac3-bd2e-7844298696ee
93	4	2023-12-25 10:32:16.700806	06fc6bd2-a8bd-43be-bb65-6c280a7a6bab
82	2	2023-12-28 21:40:16.081204	44622251-8931-4c7f-9190-2ebae7053a11
104	2	2023-12-28 21:40:16.570652	a5a42789-03cd-43c6-8177-c77ee77002d0
100	1	2024-03-02 16:54:57.722841	4087fe96-f6df-41d6-b972-91a1542181eb
107	1	\N	4d009fb9-1c24-497b-bd5a-1e89b1ee236a
106	1	2024-03-02 16:54:58.929947	c4e2e58c-123e-48b8-90a3-5d53c101962f
108	27	\N	b356dbab-7ee6-492e-b5bd-6600e5c76f95
109	28	\N	72c0bffb-ca22-4135-b3c3-a2217fcd8529
111	30	\N	8b3a2d41-2a6c-4ae6-a7fd-33725d575347
112	31	\N	52679d0f-c107-46ac-983b-e0cc387aa4ae
113	32	\N	e86217f6-9b3c-47e7-a3e7-72cf8ecd2de1
114	33	\N	b7bbad54-aec7-43b0-9ef9-eab0b1dc5957
115	34	\N	b09cbbfe-5fe4-473c-92f6-c32b693eaa0e
116	35	\N	be71f512-7040-41f5-805b-0f559e4f58aa
117	36	\N	47a1b280-6313-4221-8dd7-37359b13de77
118	37	\N	591de3a9-0852-4a59-b428-c90c40f84490
119	38	\N	717b758a-bd53-4ae1-b217-ae384c25cbe0
9	12	2024-04-03 14:19:54.726218	569a26fe-5b6f-4069-9f57-14e5a95358eb
105	2	2024-04-14 23:02:06.025108	9312eba8-f695-4b1d-8f8a-c03c866f65d0
120	39	\N	fa7e2029-b3d7-4ea3-81ee-6fc029581fb9
121	40	\N	030d9314-db89-4865-9b49-e980605b1626
122	41	\N	7bc52877-b391-4575-b250-978024b3ce41
123	29	\N	fc5d09d8-05c7-414b-852e-b02ef7f5b44d
110	29	2024-03-14 13:28:08.296193	5d8e7fc6-672b-4422-9450-7e5805c40fc2
124	12	2024-04-03 14:23:00.064914	caf568ef-b4d5-4451-8028-a3a157a00914
125	12	2024-04-03 14:37:11.869045	3c204746-7bb1-4c79-822e-ea230be9d0c6
126	12	2024-04-03 14:38:47.413975	e4ce6869-baf6-4bcb-b865-f3ee8dbff2e1
127	12	2024-04-03 14:40:54.179256	7f5af655-d3b5-4b3c-83ef-d4ead11106a3
128	12	2024-04-03 14:42:08.265708	57fd7316-ad40-4521-8475-c3d5e86d9c42
129	12	2024-04-03 14:43:53.351175	322c3ede-95be-4b56-9aab-73a0d267ba7c
130	12	2024-04-03 14:45:24.432016	6f8fc941-6915-4b4c-9437-efc168b634e3
131	12	2024-04-03 14:55:36.486935	379b063a-d32d-4e24-a147-3532bc559443
132	12	2024-04-03 14:56:30.50287	3b3f9cb7-f4cf-436f-af2e-4ce3ce3f5ebe
133	12	2024-04-03 14:57:16.417387	12d19687-3952-4555-8fa3-0ff760681c20
134	12	2024-04-03 15:06:39.983129	44c75a40-c8a6-4354-a2d1-3449ccd86fa1
135	12	2024-04-03 15:10:12.533914	a9fe96c7-fa12-4b02-8beb-1d7ea414b960
136	12	2024-04-03 15:10:21.351767	928d9e9e-81ba-45d2-95da-1dff9045882b
137	12	2024-04-04 08:54:58.215999	a337acb9-2a0a-4ea0-8a1a-f4893705738d
138	12	2024-04-04 08:55:07.289251	df6243a3-67f0-4410-ad4f-03bd1d72b57d
139	12	2024-04-04 08:55:28.859988	2b7dad2b-91e5-4e3e-8295-449b9e743362
140	12	2024-04-04 08:55:37.576981	9fd71c03-333e-4b92-b7d9-ced54a612395
141	12	2024-04-04 09:24:55.708315	501e2e68-ae80-4a64-bf27-d276236ee25e
142	12	2024-04-04 09:26:28.563783	2a94ccce-fea1-4b82-baa4-6906d5b1bd6e
143	12	2024-04-04 09:36:22.070308	96de003c-b584-4dd4-980c-c22f24ba3cf6
144	12	2024-04-04 09:36:31.001827	2a1c7253-1040-4a3b-b82a-987be408f674
145	12	2024-04-04 09:37:44.180929	e4455246-fa1c-49f2-8ca8-01e920f8985d
146	12	2024-04-04 09:37:53.061661	b100d5cc-d7ac-4695-afc2-fec983ca477d
147	12	2024-04-04 09:38:07.640339	6d8df9e2-03fe-46e6-9715-e056c98d0873
148	12	2024-04-04 09:38:16.437129	f2e07bd9-4019-4e8a-a660-7ca37d1ad76b
149	12	2024-04-04 09:38:19.17062	3dd6525f-7ca7-49a3-8474-98577ae0648d
150	12	2024-04-04 09:38:26.931625	24584dec-0496-4c84-8188-ed33506cb52b
151	12	2024-04-04 09:47:47.308447	fad30e80-ed2d-4cba-98c2-a5b4192af58f
152	12	2024-04-04 09:48:44.173584	c0bd1abb-5d8d-438e-909d-7bef12055213
153	12	2024-04-04 09:48:50.287195	b361dffe-3dc0-46c0-9578-8a2d0891845d
154	12	2024-04-04 09:49:30.806779	06eecd2e-2238-49fc-9405-a321b0d3b63f
155	12	2024-04-04 09:49:39.557376	642d6844-fe5b-475e-b8a5-dd32b41c26fe
156	12	2024-04-04 09:49:42.291253	0230ffae-2da4-4447-bce3-95fad0bdaf69
157	12	2024-04-04 09:49:46.809316	8ff39721-434b-453a-b833-a130a8bb3058
158	12	2024-04-04 09:49:48.931122	26f2bb69-5667-44b6-a3eb-114a39d5f744
159	12	2024-04-04 09:49:55.252201	17db4480-2708-4408-a847-b6871bbbddc3
160	12	2024-04-04 09:56:30.294482	0909ad64-a055-4277-85c5-7cbdf8298e34
161	12	2024-04-04 09:57:07.155381	d9eee6d5-6109-4c58-8406-6ee3b2575e50
162	12	2024-04-04 10:01:17.051557	536eada3-238f-46c7-adcf-a48ff2131ce5
163	12	2024-04-04 10:01:22.337607	bf85eb95-c816-413f-b505-e2436737aab4
164	12	2024-04-04 10:01:41.422783	675cd345-6022-4efb-b32d-9c1cf6befa24
165	12	2024-04-04 10:01:50.306677	e70a74e9-1180-4de8-8460-26e5b00d04ef
166	12	2024-04-04 10:01:53.05545	1fec31ad-921b-4d65-a287-6fbf5ad9a917
167	12	2024-04-04 10:01:56.631934	fcf274ca-4dd0-4d32-b36c-df1a425192dc
168	12	2024-04-04 10:01:58.662654	d35d113d-99a4-4d4e-8d9b-daf2f767f270
169	12	2024-04-04 10:02:03.037114	f666fa04-bb92-4101-a07a-549281c62df2
170	12	2024-04-04 10:02:05.051268	00a495be-c203-4a83-b36c-06cd8f6ccef0
171	12	2024-04-04 10:02:11.974094	e8ebfb23-e558-44ce-b64e-743c2a38b1f0
172	12	2024-04-04 10:05:55.856968	1b8f4c0f-ed56-4975-a089-0f89f1c720b6
173	12	2024-04-04 10:06:05.601528	cc3bbac2-78e9-4f0e-992f-3f00166c4490
174	12	2024-04-04 10:06:08.304424	d893f8db-1561-4687-a1d2-eee498816b5f
175	12	2024-04-04 10:06:12.584771	4fd5d259-06d9-4048-95ef-370eb5a9220b
176	12	2024-04-04 10:06:14.767638	b27360ec-007f-44cf-a30e-b216b18c5c15
177	12	2024-04-04 10:06:19.660708	2cfc195f-3d53-46cd-a0a6-8f5417aaded8
178	12	2024-04-04 10:06:21.731193	562000f2-eeca-492b-afb7-a8e5f03a4e47
179	12	2024-04-04 10:06:28.796385	f33eed35-62b9-4cdd-a8f5-f0bee29e4774
180	12	2024-04-05 10:43:08.292278	4f45798f-14a3-4e71-a261-5c62d5f94433
181	12	2024-04-05 10:44:49.295812	8e7d58f2-ffb4-4f22-8527-04a1c9f9733b
182	12	2024-04-05 10:53:57.517438	502b082f-4409-4502-8014-5ddfd4380d16
183	12	2024-04-05 10:54:07.947064	50dd4e0b-2ed8-47e8-8207-9161fd8589c7
184	12	2024-04-05 10:54:42.147691	f0657745-bf7e-470b-9c80-ad55afab0e35
185	12	2024-04-05 11:02:37.68844	956e8f59-8a1c-428f-936c-2b690dc9f1dd
186	12	2024-04-05 11:02:50.838466	009c21a0-f6b1-4416-a645-c39afbe37718
187	12	2024-04-05 11:07:23.81943	37bb9f64-2581-498f-8094-0bab726f41a8
188	12	2024-04-05 11:07:35.406226	2187599a-44a0-41d2-8d40-53e4f070a253
189	12	2024-04-05 11:08:29.708143	7ecc8b4a-41b7-4112-8b28-b2fee0edd692
190	12	2024-04-05 11:08:41.84958	f4a10511-a18d-4548-87c9-dcde51d3db71
191	12	2024-04-05 11:21:38.679255	23b56e64-f7c9-4f10-a05f-e75223bfbba3
192	12	2024-04-05 11:21:51.294459	a7f12c9a-ff34-4709-87be-e3c63dee8ce3
193	12	2024-04-05 11:22:07.761345	f438b639-4980-42a9-b299-b14d9e5a01fd
194	12	2024-04-05 11:22:16.970675	a29ec940-5daa-4202-bc74-e7b08069f901
195	12	2024-04-05 11:23:34.427182	e4e6944d-7593-4855-b105-f9cf02a389d6
196	12	2024-04-05 11:23:44.12972	a3a44933-5670-4638-b7fc-ac0a5e33140c
197	12	2024-04-05 11:24:05.58439	b58a1626-e071-4b81-a4f3-d828f6aae6e3
198	12	2024-04-05 11:24:15.020286	e807164f-e2f5-4d0c-b4f4-cf05e37ab1ea
199	12	2024-04-05 11:24:17.697936	bff83393-d519-4d26-bd58-c718d186b842
200	12	2024-04-05 11:24:21.883624	662704fb-6bf8-41c5-a638-6b2746781266
201	12	2024-04-05 11:24:23.906521	53577fb6-8abe-447e-a351-51e08145c008
202	12	2024-04-05 11:24:31.94843	1f424bbb-6922-4a36-830a-1e34ef1456d4
203	12	2024-04-05 11:24:33.810636	3755208f-c9c9-4494-850d-6b9773fa6fe7
204	12	2024-04-05 11:24:38.567077	028211d7-521c-47ea-aa0b-31a26ab910bd
205	12	2024-04-05 11:24:40.44827	35a75b5a-3c79-4251-be3f-0c474428f584
206	12	2024-04-05 11:24:47.209711	1ccd1357-2fb6-4fa6-8f13-4338cbba9713
207	12	2024-04-05 11:24:49.090405	7cc0a651-d9a3-47d6-9150-1069827dabd2
208	12	2024-04-05 11:24:56.269985	66b438fa-b4a5-45e3-b63a-201dd3d90cc9
209	12	2024-04-05 11:24:58.201943	8c52f9fd-59a6-4899-87bb-4d3b28a6ff34
210	12	2024-04-05 11:25:08.040057	8655dead-d357-41bf-8c67-7913740d02d4
211	12	2024-04-07 05:01:17.850329	a0bdf2d9-5b9e-4ab8-901d-f010eaf9ced0
212	12	2024-04-07 05:01:29.279838	b2eb8d8d-f098-458d-a665-e8a067660873
213	12	2024-04-07 05:03:14.632301	620d6220-6d03-462f-a987-e8814295f6c0
214	12	2024-04-07 05:03:23.856694	9cc02a56-baa0-4929-bf52-e7f48ac7a287
215	12	2024-04-07 05:03:29.073563	668e00b6-d580-4d49-870b-a28343de64e3
216	12	2024-04-07 05:08:40.665829	bae3251f-6e45-403c-9819-ddec4613ae21
217	12	2024-04-07 05:08:51.041577	9e6ad767-8046-4441-8859-1edbbbbebe70
218	12	2024-04-08 07:34:17.131917	26ad3fc4-cf83-4693-8b10-30a15c6409c8
219	12	2024-04-08 07:34:26.573304	eb016b96-efa0-43e9-82f7-f68435aa24c7
220	12	2024-04-08 07:34:29.482071	adc89910-6721-4261-b32b-004427f0ebda
221	12	2024-04-08 07:34:34.053501	a7ec44f7-a8e6-4540-b899-7357fbcf1187
222	12	2024-04-08 07:34:36.207715	603657ba-d834-4e8c-9a17-e6cb485912b4
223	12	2024-04-08 07:34:44.724655	c0bcd3c2-40b6-403b-931f-c2cb50eab574
224	12	2024-04-08 07:34:46.783523	961e6794-079e-4ffe-833e-e6bbe3965ed5
225	12	2024-04-08 07:34:51.815963	9ccdac96-1b7b-45fe-a3ba-eed6e0696d49
226	12	2024-04-08 07:34:53.821545	f1f3146a-3e33-4b04-835b-c1b7abac830f
227	12	2024-04-08 07:35:01.57163	282fd0ef-9c4b-4d36-99d9-72f127ed5466
228	12	2024-04-08 07:35:03.632493	6dbde2a0-12e5-4645-b6bb-c5700129c7bf
229	12	2024-04-08 07:35:11.199779	ee0e0484-4595-4d0a-91ed-724b53fb0dfd
230	12	2024-04-08 07:35:13.29599	67fb9c05-11ef-4f9e-bd47-bf523c4baba3
232	12	2024-04-08 07:35:23.479458	c6f71c0b-eea4-4ee0-8cc6-88adf15caa60
231	12	2024-04-08 07:35:21.263991	6b624a82-c1be-415d-8f71-b5b9b61a528a
233	12	2024-04-08 07:35:34.03719	5e8dbdf3-e97c-4901-ab62-4fedc57a85d3
234	12	2024-04-08 07:35:36.330288	0284d1b6-87de-4462-b196-c4f222b8d82b
235	12	2024-04-08 07:35:42.996925	77de0134-4964-43f1-8f7d-e17860b17e36
236	12	2024-04-08 07:35:47.594802	a1b656c6-677a-4afa-a5c0-48b97c4a8057
237	12	2024-04-08 07:35:49.851475	b54625a9-d064-42ad-8623-744be13f8126
238	12	2024-04-08 07:35:53.628929	2de00558-6826-4759-aca0-008ffc6a9abb
239	12	2024-04-08 07:44:20.471627	309641b7-fa1e-468d-a0b1-7f1ef1ca0d98
240	12	2024-04-08 07:44:25.346558	73bf0bee-9415-48af-aa3a-d18c15bcdea7
241	12	2024-04-08 07:44:26.146903	460ecca4-1668-4351-843c-f64757d91ba8
242	12	2024-04-08 07:44:28.099863	cdde8467-62c3-4250-9526-d9fd44489ca9
243	12	2024-04-08 07:44:28.796383	6bea07f0-818e-4c61-b03b-e5a09720e39b
244	12	2024-04-08 07:44:29.524352	f6504914-7b81-484f-83ec-76e698976f48
245	12	2024-04-08 07:44:30.59961	497e4350-9d08-4bc3-9fdd-74d426e316cb
246	12	2024-04-08 07:44:30.911138	41afa12f-8f6b-444e-8ac2-d41bd55efaa5
247	12	2024-04-08 07:44:31.672882	0ef25fa2-f179-4409-b4b7-cea7c11be731
248	12	2024-04-08 07:44:32.925856	147e841e-8b05-40eb-8ee2-5c20b1bd2e4c
249	12	2024-04-08 07:44:34.310213	0c982396-68dc-4c4b-8f7f-bb94ad355280
250	12	2024-04-08 07:44:36.677617	f9a5f9ae-cb8e-4ff3-800f-4585fca05029
251	12	2024-04-08 07:44:37.304949	5984948c-2d2a-49d9-8c73-00bd285e64b4
252	12	2024-04-08 07:44:38.065778	6a400ff3-07ea-427a-b818-4496517eaf2e
253	12	2024-04-08 07:44:38.405007	247cbfb0-2b1f-4f00-949a-0aa429fb30d2
254	12	2024-04-08 07:44:40.438424	ccc26e34-f870-4438-9e14-57b6e5b4cf64
255	12	2024-04-08 07:44:41.599973	9748bc6e-eed1-4ffb-9792-ca81d5501a84
256	12	2024-04-08 07:44:41.651943	38f54a43-7e81-4291-8cec-0726a8b7b555
257	12	2024-04-08 07:44:42.960027	d93b3477-c3eb-465c-ba63-276569eb1de7
258	12	2024-04-08 07:44:44.327542	72dd2957-8ec7-4342-b7ac-d949d1276614
259	12	2024-04-08 07:44:45.244312	0a948da4-ca57-4346-84a0-cc0285e03997
260	12	2024-04-08 07:44:45.698915	fa30f738-6561-48bb-a98e-60c24ad2a6df
261	12	2024-04-08 07:44:46.341022	546d07f5-1a19-4ebb-9701-e9e654483250
262	12	2024-04-08 07:44:47.444301	cd427491-6ec0-4ad2-8bce-5a6dbf214cce
263	12	2024-04-08 07:44:48.67233	db5659be-19d4-47f7-af5a-2ec0f87f0cbb
264	12	2024-04-08 07:44:48.712289	0f14f54b-3339-4369-9b88-184ab45f6960
265	12	2024-04-08 07:44:50.000309	d5e56bf4-0f3e-4caf-aee3-7a669f19c2bd
266	12	2024-04-08 07:44:50.208484	5b062476-1038-4ea3-9a18-d87db900a0f6
267	12	2024-04-08 07:44:51.22692	3104748e-6964-450e-a2ab-6edfd52151ef
268	12	2024-04-08 07:44:51.6324	bde663b8-7813-4aab-b4d2-54bf27578175
269	12	2024-04-08 07:44:53.726295	1e2d1f3d-502c-4f8c-b47d-c755a348ac75
270	12	2024-04-08 07:44:54.422637	f8fe94ab-aa04-46ad-9ed1-bba61b64c2f3
271	12	2024-04-08 07:44:55.181061	0677f970-31fb-4f40-937a-85e30a10538b
272	12	2024-04-08 07:44:55.543111	87696a11-a6a1-4d9e-a9a9-a7d1ad087714
273	12	2024-04-08 07:44:56.664184	683806b6-0e81-4e1c-9bcc-482f120449f5
274	12	2024-04-08 07:44:57.648268	c1e2872a-9894-4e2d-b460-c38b809e8085
275	12	2024-04-08 07:44:57.811028	c44d50c2-4b61-4101-820c-b17fb01354a9
276	12	2024-04-08 07:44:59.722437	c6697da7-a835-48ec-b008-d593b87c426d
277	12	2024-04-08 07:45:51.523186	2f5ef05d-ad60-4456-807f-7d84ec4f9d5e
278	12	2024-04-08 07:45:52.840722	29f7f8be-4626-462c-b398-7085998ea3ef
279	12	2024-04-08 07:45:55.164152	1dd20da3-8b9d-4c1e-be60-bb713ca7fa23
280	12	2024-04-08 07:45:57.656282	521ebed3-7a5a-4d51-b70e-773d6c677405
281	12	2024-04-08 07:45:59.015535	4ccc3f82-5c45-40d0-ab83-0450fdf7cba5
282	12	2024-04-08 07:46:01.628317	4e768165-fe52-4828-a1d5-4263160b8d0c
283	12	2024-04-08 07:52:31.833762	d5918824-5153-415a-a12b-979b0f74d854
284	12	2024-04-08 07:52:37.240049	12534e8b-7e90-4b76-91e1-f294d390197a
285	12	2024-04-08 07:54:22.869433	fe33cdcd-8f8a-475d-ab82-1f87932f97e1
286	12	2024-04-08 07:54:28.141695	d1bd5d1d-54f0-4ae7-86fd-74ee2db908ee
287	12	2024-04-08 07:55:19.352411	721f6c69-eecb-4655-b9ba-7fb178d9c6ce
288	12	2024-04-08 07:55:19.352411	74f4deb6-16f0-4434-bf5f-094eaa88e87d
289	12	2024-04-08 08:02:42.871333	34ce60c4-e1f7-4c5c-b157-9f167d473efd
290	12	2024-04-08 08:02:52.25571	def7d6f1-6782-4cd5-ab46-825575262729
291	12	2024-04-08 08:12:14.108623	4c2e2853-60d1-4f09-81b1-c32fc0900b44
292	12	2024-04-08 08:12:18.476397	1468cae3-89c5-475f-a2f7-76a867f5eac9
293	12	2024-04-08 08:12:19.930867	35c280a6-584e-4b81-b731-454b822c3118
294	12	2024-04-08 08:12:21.790401	e20ac9c5-82df-403d-bc12-0703547ca3fa
295	12	2024-04-08 08:12:22.77668	824e96f7-30fd-41e2-b46c-dba131d4bdff
296	12	2024-04-08 08:12:26.135465	4faaedf8-5e1e-4751-8746-9eba4308abf3
297	12	2024-04-08 08:12:27.124845	75536274-de2b-4fb8-85c2-611022ba1cad
298	12	2024-04-08 08:12:29.262074	bfc2764e-0440-4d16-a26b-e44d90c187bd
299	12	2024-04-08 08:12:30.258663	42c0f652-ba74-4cf5-8a8f-da6fc0889625
300	12	2024-04-08 08:12:33.146999	9b9ef002-d5f5-4acf-a824-cbe5afa3d8ab
301	12	2024-04-08 08:12:34.154911	5978575a-0bb3-49ca-b7fe-0e985e210927
302	12	2024-04-08 08:12:37.175903	375842ec-46fd-4882-ad46-7673eb3beb9b
303	12	2024-04-08 08:12:38.166346	035713b3-65ad-4be6-a1ea-35f63ecea6a6
304	12	2024-04-08 08:12:41.424215	4621e397-aa73-4fdb-b5a0-3d53b13686e3
305	12	2024-04-08 08:12:42.40877	65d3ea27-27e2-4dad-a0ec-c4d304f878c1
306	12	2024-04-08 08:12:46.522835	ad83a347-f338-404e-9574-d40682dc948b
307	12	2024-04-08 08:12:47.535869	843799f8-82f0-4a5e-9172-851093df22f4
308	12	2024-04-08 08:12:50.174013	61ee0ecf-4afc-4e5a-a2b2-ea4e53affa47
309	12	2024-04-08 08:12:51.880205	115a24c1-ef86-42aa-baad-4aab4cb03aaa
310	12	2024-04-08 08:12:52.909959	3ff81f75-78cf-49b4-bc46-52e798abfeb6
311	12	2024-04-08 08:12:54.375553	55a4f806-067f-416d-a397-0ccc318327dc
312	12	2024-04-08 08:23:48.056413	ed09fd04-51b4-4ed2-a6c3-9c5a02b8962b
313	12	2024-04-08 08:23:50.848876	df357da1-9468-4fc9-aa2b-2a7780fdc662
314	12	2024-04-08 08:23:52.496277	448c9191-db7a-445e-8df9-ec43944c5619
315	12	2024-04-08 08:23:55.806139	1fb91e3d-4168-40fc-a9ff-a07ddfe4c076
316	12	2024-04-08 08:23:56.842559	481bc316-8434-4b4c-9a53-f2b37ebe880d
317	12	2024-04-08 08:23:58.784345	c1c147e9-85fc-40d0-b5bd-395fe36f0e0d
318	12	2024-04-08 08:23:59.8363	a2480435-77e6-4be5-b520-847f58b82db6
319	12	2024-04-08 08:24:03.467762	0430b6c0-7be4-4869-bfd5-e6a820930bac
320	12	2024-04-08 08:24:04.507011	766dfda9-52e5-4ab2-baed-cc1384e9ff67
321	12	2024-04-08 08:24:06.707167	aafd6b88-6a97-4a8b-bc99-38b78e5f4d0b
322	12	2024-04-08 08:24:07.732016	256d919a-9589-4f47-949d-cb6a6aa9aa2e
323	12	2024-04-08 08:24:10.772411	56d31bfa-b240-4ae9-bd36-8e37f01c8ae7
324	12	2024-04-08 08:24:11.844362	fac27709-c268-406a-baec-05cf73a38594
325	12	2024-04-08 08:24:15.036348	05bc13b1-5d75-4484-8b20-674528d1effb
326	12	2024-04-08 08:24:16.116754	714649a0-082e-4f04-adde-414051acbcb8
327	12	2024-04-08 08:24:19.48216	1fcbc422-9d5d-4675-95f5-b90c9c6bcb2d
328	12	2024-04-08 08:24:20.474064	0b68e8a3-075b-429a-a74c-f3683d829331
329	12	2024-04-08 08:24:24.719215	d0d8a046-bcfc-4a7d-b318-000969dd42ef
330	12	2024-04-08 08:24:25.734408	5e434231-a6f3-4172-ba7c-e12f93ebc7b0
331	12	2024-04-08 08:24:28.477744	7380e0cf-ef7f-4c60-a9b5-d82bea6a32ef
332	12	2024-04-08 08:24:30.240516	7ab0481d-d145-4029-8ef5-3c6262e4ba70
333	12	2024-04-08 08:26:23.409527	94652827-645d-40fa-9cd6-85385e2201e2
334	12	2024-04-08 08:26:27.856391	f05e565e-e72d-4bd3-9ee9-8af15798307b
335	12	2024-04-08 08:26:29.370101	1836726a-b785-4113-9222-09cf8b8bf9ec
336	12	2024-04-08 08:26:31.223488	ce7aa027-1690-4fa2-8837-f4d78795ab78
337	12	2024-04-08 08:26:32.251507	71752ccc-a706-4d7f-b9a2-2093aabe04c6
338	12	2024-04-08 08:26:35.6214	dfe9fe89-449f-4cc5-ae4b-50bc3634542a
339	12	2024-04-08 08:26:36.67264	2da53aa3-30e7-49e8-ba6d-3418e92d91ec
340	12	2024-04-08 08:26:38.771356	b3981821-35fd-402d-be5e-040a2df7b31d
341	12	2024-04-08 08:26:39.731561	ec5457c9-4f4f-4a10-9ceb-a3a6c80d7673
342	12	2024-04-08 08:26:42.663827	7a576525-4f72-4f24-a35c-e07691206b37
344	12	2024-04-08 08:26:46.768561	3abef901-0f0d-4630-8775-e8131b0b00f8
343	12	2024-04-08 08:26:43.636782	09d6e3cb-3f9e-43b7-bfe6-0ed90b9d5b56
345	12	2024-04-08 08:26:47.73529	15b2058b-0489-4b26-9a76-0988d62032f5
346	12	2024-04-08 08:26:50.96606	cbdc68cc-d961-4fac-86b0-07acaa80ab55
347	12	2024-04-08 08:26:51.907665	9fe54416-7115-4f36-ba70-97a7a755e66a
348	12	2024-04-08 08:26:56.050302	3e857658-e7e9-456b-8451-814011e57f7f
349	12	2024-04-08 08:26:57.038576	fd338776-6bf0-4ab3-8987-72df1fb89019
350	12	2024-04-08 08:26:59.701976	90dba9fd-f5f5-4cd8-9eef-1db198d13c55
351	12	2024-04-08 08:27:01.412381	0490ec8d-160e-46b0-98dd-6c462350e6ea
352	12	2024-04-08 08:27:02.544349	9550a532-e937-4430-9ca2-f9b0547895a5
353	12	2024-04-08 08:27:04.088339	1cb3be3d-5f18-4339-94ab-c00df8d6abb8
354	12	2024-04-08 08:27:45.593391	1df6d7cc-ef01-4096-b7f0-d70898a1ef89
355	12	2024-04-08 08:27:51.795567	9ff3b136-2620-463a-8c05-a71a25b025b3
356	12	2024-04-08 08:27:53.7867	90b30521-92de-4949-a502-3473dd2056e4
357	12	2024-04-08 08:27:56.707834	fafefb17-2b47-4c91-b5b9-2cad61e817cc
358	12	2024-04-08 08:27:58.223618	a83c467f-c4ea-43f4-be87-05880c5280b3
359	12	2024-04-08 08:28:03.65737	dd8eb82b-ecd2-4b4f-a215-956e12aac7d9
360	12	2024-04-08 08:28:05.195538	2b3e36c9-cf72-406a-96b6-6d52d4e2baaf
361	12	2024-04-08 08:28:08.57814	8b945430-1be5-40af-8503-5d416817bdaf
362	12	2024-04-08 08:28:10.135532	7174bffa-540d-45bb-af68-b30e98e4869f
363	12	2024-04-08 08:28:14.7576	21edbf93-cd8f-40b7-8845-25d31e46f136
364	12	2024-04-08 08:28:16.358274	20ac24ab-ac22-4603-b248-70292f8482c2
365	12	2024-04-08 08:28:21.137972	02022a3b-8020-42dc-b867-f56917e705ae
366	12	2024-04-08 08:28:22.675526	16b17cf2-15aa-4217-b9a8-862a6945a863
367	12	2024-04-08 08:28:27.816442	2bb7c88a-4915-456b-b54a-c0e9f4a2c380
368	12	2024-04-08 08:28:29.360555	72ec6cf8-5246-4a4f-8934-f0c63335bd06
369	12	2024-04-08 08:28:36.007901	d33a6d5a-e94f-4ac1-850b-ef46c3a78afc
370	12	2024-04-08 08:28:37.52276	4facfd37-24fc-4606-a0c8-7aa378bb3a02
371	12	2024-04-08 08:28:41.793675	e65e78f6-0403-4b18-a931-7b3075fcf300
372	12	2024-04-08 08:28:44.542216	7ace4a74-d389-48fc-b225-7fe6b9ebd02a
373	12	2024-04-08 08:28:46.134125	4aee1b0e-1375-4967-950f-99421a8abf0b
374	12	2024-04-08 08:28:48.563782	31e19ef4-6617-4acd-b7b9-4178a39f528b
375	12	2024-04-08 08:57:11.296631	b361cec3-0c2f-4c3b-96c5-f7eaa1d393f0
376	12	2024-04-08 08:57:14.064355	5b68afb7-9ced-40d7-aa6d-fde51fcf6566
377	12	2024-04-08 08:57:15.671697	ffa54b6e-a807-4b7c-a659-96fbd6567da1
378	12	2024-04-08 08:57:18.923783	1be0cc5d-987a-42d8-bc94-59380f6e3ef9
379	12	2024-04-08 08:57:19.916082	28a0c7a3-714b-436e-b8a5-a0f5e68d6937
380	12	2024-04-08 08:57:21.776677	c0ad7a25-e8b0-43a1-a7b7-64fb8c651082
381	12	2024-04-08 08:57:22.778224	e521a6a9-c1d3-48d0-8982-d089269f2ca1
382	12	2024-04-08 08:57:26.177781	70e1650c-a867-43f8-ab5c-50f1e767a099
383	12	2024-04-08 08:57:27.190602	4df66e91-e697-4071-9448-04ebb54f5116
384	12	2024-04-08 08:57:29.380391	56ac5584-89b9-4430-8cf7-9d4958dc0a95
385	12	2024-04-08 08:57:30.387263	08f047a8-bbd9-4094-8061-fb06a25279d5
386	12	2024-04-08 08:57:33.374388	24707003-6b41-40f3-9536-9a764cbc506f
387	12	2024-04-08 08:57:34.360774	f5eae8ad-1b82-4ed8-b9ca-ca12417f4552
388	12	2024-04-08 08:57:37.405342	0d02ed18-8f15-4d23-90d2-afbf1138ac3d
389	12	2024-04-08 08:57:38.373376	9f330a7f-a8e3-463b-8e06-2a8b13b08711
390	12	2024-04-08 08:57:41.650289	bf148b2c-be8e-430d-880f-97515c62ef99
391	12	2024-04-08 08:57:42.61701	0e671ade-2050-4a16-b90b-6f467af09a98
392	12	2024-04-08 08:57:46.798432	aa64cb88-35f2-4259-860e-84b6484c35d8
393	12	2024-04-08 08:57:47.780918	7d6a9811-72a1-4c67-a660-2c93b9fd7a42
394	12	2024-04-08 08:57:50.454501	f1f52415-887f-4cb1-be2e-52e71d1b5ca4
395	12	2024-04-08 08:57:52.149134	666cecfb-b8ef-4aaa-bc88-f2ea9ad9f724
396	12	2024-04-08 09:07:12.56326	4d8599a9-bb4d-4c5e-a5c5-24ac4b028a1d
397	12	2024-04-08 09:07:19.306726	596169d5-857f-495a-ae16-e52a069397f6
398	12	2024-04-08 09:07:21.341617	72dce28b-b4f4-4e23-82eb-f486e17ab50f
399	12	2024-04-08 09:07:24.275409	58b39c81-ab60-41a9-beb0-83f37ccba75f
400	12	2024-04-08 09:07:25.790895	d8463f8c-13d6-4bca-9579-9e38a6f192a5
401	12	2024-04-08 09:07:31.133247	34d4cf09-75cc-48ac-9b2f-78eeabc46cb6
402	12	2024-04-08 09:07:32.664304	a4853b5b-2141-4ab9-bc42-2e0bbab88a2e
403	12	2024-04-08 09:07:36.021358	0c6c32e3-b658-4b6e-93df-b941ae0af983
404	12	2024-04-08 09:07:37.561302	35eda178-a9c6-4188-871e-490bad85e7c3
405	12	2024-04-08 09:07:42.256343	bef953ee-4cd8-4073-8545-75fb9a888ee8
406	12	2024-04-08 09:07:43.854299	fba5f9ca-ab86-42f6-8e95-f374c95e1ded
407	12	2024-04-08 09:07:48.60741	f5cc0d33-b13f-4cd7-b5e9-7038ba6dd2f0
408	12	2024-04-08 09:07:50.138234	2542c596-8908-4e00-ae7a-b8588acaa935
409	12	2024-04-08 09:07:55.263392	4081ab54-66ca-44ca-998c-d213f922bd31
410	12	2024-04-08 09:07:56.77316	e09f052e-fe42-4e5f-a5f1-9aac61fb7f1c
411	12	2024-04-08 09:08:03.480447	23079eb1-5d60-46fe-a95d-02df57da4898
412	12	2024-04-08 09:08:05.042812	18f732ce-47d6-4641-9a2d-44eb7636919a
413	12	2024-04-08 09:08:09.291791	f7cbb3e3-baa3-445a-807b-27c634c2f0bd
414	12	2024-04-08 09:08:12.011301	8480e2cb-930c-43ee-b33a-958010ba533f
415	12	2024-04-08 09:08:13.557821	3d6114d9-02b5-4246-ae08-a158163e9cd7
416	12	2024-04-08 09:08:15.941114	f984fdd0-cb30-47f2-b888-397bb57d3340
417	12	2024-04-08 09:09:15.574885	a82e6c4e-3791-4b6d-97f6-796f14cd5166
418	12	2024-04-08 09:09:21.318481	814c4ff0-1f8c-4661-9c50-3a0f7e620ff7
419	12	2024-04-08 09:09:23.22917	661b847d-b6dd-45b5-847b-287705215749
420	12	2024-04-08 09:09:25.834565	345189d4-be15-47f8-9bf7-04113480bd98
421	12	2024-04-08 09:09:27.237921	4bbae745-73e8-4c6f-99dc-b6bbaad4e919
422	12	2024-04-08 09:09:32.042807	a1c1c866-e9bb-47cf-a8c2-15fdb5ad94ea
423	12	2024-04-08 09:09:33.430964	7dc46c3c-428b-491d-8cb0-21ed05614b6c
424	12	2024-04-08 09:09:36.490648	37d5fa44-d599-4944-9407-d9c94a9aa262
425	12	2024-04-08 09:09:37.889542	be0ce7c8-59c8-435f-aebb-c45bea338b18
426	12	2024-04-08 09:09:42.082249	397a261c-21eb-496b-9940-5b68a4df3803
427	12	2024-04-08 09:09:43.465398	0f59992f-6a72-40f6-90e5-4317b69e1b21
428	12	2024-04-08 09:09:47.842677	2890c677-79e8-4ef4-aa54-52954a5ee941
429	12	2024-04-08 09:09:49.191411	00bc6333-1f30-4998-b5e2-c48b248f4be1
430	12	2024-04-08 09:09:53.996276	4d909985-1a2d-4080-b9f5-ba8dd7da419d
431	12	2024-04-08 09:09:55.360266	b2821950-f8d7-4e97-9e6a-b034489c874f
432	12	2024-04-08 09:10:01.39429	ed96e891-4af9-401c-a85d-31d8590637dc
433	12	2024-04-08 09:10:02.988471	9e72928c-0515-4ebc-a649-9518ea761d4f
434	12	2024-04-08 09:10:06.947103	061256d5-3572-4278-869f-11ebc97ede7b
435	12	2024-04-08 09:10:09.38684	68a42665-2fc8-4764-bd27-b66fa0570bf4
436	12	2024-04-08 09:10:10.765723	549fcc38-9b98-4469-b342-c9b637f5eb90
437	12	2024-04-08 09:10:12.873691	3393ea3a-ff79-4939-956e-e01dde110593
438	12	2024-04-08 09:12:36.937921	4970c5a8-f033-4400-b217-8e2f95fdc553
439	12	2024-04-08 09:12:43.216088	95bb0552-c206-4d21-9ae3-6f037044427e
440	12	2024-04-08 09:12:45.21131	bcf22028-b754-4f06-8e84-9d7fd17c34b0
441	12	2024-04-08 09:12:48.087782	06afa67b-3a90-4eb3-88d1-fe897d8eca16
442	12	2024-04-08 09:12:49.59629	5e4db20e-7f8a-4cc6-8845-41f32197b498
443	12	2024-04-08 09:12:54.925597	d927634e-cae6-4aba-bc1c-294ba9ecd244
444	12	2024-04-08 09:12:56.453878	2f8cf89c-9a70-4fea-ab4b-f67ea20e4167
445	12	2024-04-08 09:12:59.846035	e63a87d3-c790-4ddb-8b83-ea36d5981901
446	12	2024-04-08 09:13:01.362491	eee34ae2-b92d-4de3-ac16-90416d7d75ee
447	12	2024-04-08 09:13:06.025944	142e7b95-2e1a-43af-a489-e9e9438623cf
448	12	2024-04-08 09:13:07.592176	7ba3d547-bd78-4392-a0a9-da43e61a7f24
449	12	2024-04-08 09:13:12.368098	6c767e32-7e62-4478-8e1f-dcaf3a291cd4
450	12	2024-04-08 09:13:13.909498	06b93878-47aa-41b6-a574-953592370412
451	12	2024-04-08 09:13:19.015934	fac3fba4-bc6d-4d12-b1fd-f0060dcb1478
452	12	2024-04-08 09:13:20.533325	5068da9f-0ca6-4edc-81d7-1d0705b706d6
453	12	2024-04-08 09:13:27.159304	56776f2d-af5d-4732-b771-4bff607da648
454	12	2024-04-08 09:13:28.653407	1285d26d-751f-4a85-9deb-e52d8dbdc614
456	12	2024-04-08 09:13:35.712285	0d352a7a-c762-408b-919d-be64266e995d
455	12	2024-04-08 09:13:33.005155	2e55bcaa-d1ab-4109-a098-0404d2a6da50
457	12	2024-04-08 09:13:37.272233	a676df12-963b-4033-a534-64f6074d7be6
458	12	2024-04-08 09:13:39.784557	847ff1a6-86ba-491e-a026-ca394e1d707e
459	12	2024-04-08 09:35:36.597122	a71a7304-197c-458c-acc6-4babd64399b3
460	12	2024-04-08 09:35:41.986894	3b3425db-7889-4316-8e59-85c3ed1c1065
461	12	2024-04-08 09:35:44.717924	7d81b5ba-d345-45bd-b68b-b713b2c221ae
462	12	2024-04-08 09:35:50.957211	3b3caff6-7968-42ba-8e53-6e4dcf59a8e7
463	12	2024-04-08 09:35:52.734911	4c2f5990-32bb-4085-8902-fdffc51b8137
464	12	2024-04-08 09:35:56.014258	c23c6a78-d1e5-4f89-bf0d-669c7216e6c1
465	12	2024-04-08 09:35:57.697728	7b279b8c-1aca-4f4e-b4b4-96a4d320aacd
466	12	2024-04-08 09:36:03.824688	2177652b-c8dc-4a12-8729-36943b82b37c
467	12	2024-04-08 09:36:05.634766	e8a0a500-8b4e-4d78-81f5-244a4221fe17
468	12	2024-04-08 09:36:09.310907	ecc548e1-c9e4-45ed-9a20-753d3af1b492
469	12	2024-04-08 09:36:10.956557	bfe39061-9b3d-461b-85aa-7c645f723071
470	12	2024-04-08 09:36:15.923682	67f97299-4778-445b-8bab-41fa44fb4499
471	12	2024-04-08 09:36:17.529809	0487a46e-e4be-4105-8cda-30a624d3451c
472	12	2024-04-08 09:36:22.712565	6a898bf0-f7cb-4d58-87bf-0d924b8f6356
473	12	2024-04-08 09:36:24.295827	668c5481-beba-438b-b211-5dcf13c200dd
474	12	2024-04-08 09:36:29.851795	8fba2c2f-19f3-43a0-8a78-c3ccca2eaf7c
475	12	2024-04-08 09:36:31.462448	dc34ad72-a1b2-4f0e-bf95-647a6267ade0
476	12	2024-04-08 09:36:38.510963	91225bdd-667a-4b77-a2b2-12634a929769
477	12	2024-04-08 09:36:40.104058	84dcf1c9-2183-40e6-bdce-743b599ee4e1
478	12	2024-04-08 09:36:44.695084	e62435fd-554b-44c8-92e9-0618bca512bf
479	12	2024-04-08 09:36:47.528376	7b8b47d3-83a7-4429-b57f-7d7097171c3c
480	12	2024-04-09 09:08:35.077089	355d27c3-aec9-44b9-848f-aa32ed78ba9b
481	12	2024-04-09 09:08:45.237423	47e97894-761d-4f46-90dc-822d280b8c13
482	12	2024-04-09 09:08:47.55976	4ff42d89-f37c-475d-b31d-f446f34e610f
483	12	2024-04-09 09:08:51.116513	9b9ed74d-f985-4ac0-bd1a-6d61e5f8be5e
484	12	2024-04-09 09:08:52.904588	19f05de3-1b6f-4e20-a7ee-f3faa2289b4d
485	12	2024-04-09 09:08:59.128669	b5f67a47-1bdf-43d9-a25a-0aecb8d20cbf
486	12	2024-04-09 09:09:00.928617	5a61b86a-93f5-4769-82a4-5bb2b2f5968e
487	12	2024-04-09 09:09:04.951569	dd388e62-c4d0-4168-8fe5-152fe4c31e17
488	12	2024-04-09 09:09:06.664553	0de9cb52-4865-4479-97b5-2ae6a850ab8a
489	12	2024-04-09 09:09:11.905542	2896e06e-d579-492c-bd07-28058d286c88
490	12	2024-04-09 09:09:13.587076	b38e80a5-41c2-4b1c-8ac5-b08ba9001cd7
491	12	2024-04-09 09:09:18.842661	f5a58b0d-9d40-45f6-b43c-7e569f262eb2
492	12	2024-04-09 09:09:20.49246	fe0ee17b-ade4-43ee-a14c-178eb6279244
493	12	2024-04-09 09:09:26.140453	1fb2636f-3d52-486d-91d4-4ee2f8435061
494	12	2024-04-09 09:09:27.789877	290dbc98-ef05-44c8-bba6-f7a27dc62b5d
495	12	2024-04-09 09:09:34.957073	f78dc14c-3369-478b-ab7e-dd24a16086d1
496	12	2024-04-09 09:09:36.579589	0d056a34-c9a4-459c-abce-dd64ccd5302e
497	12	2024-04-09 09:09:41.273979	98ffbc3b-60cd-4196-9140-89573654f36a
498	12	2024-04-09 09:09:44.159349	c388f3a5-3cb5-48dd-b314-2366b1b6a77d
499	12	2024-04-09 09:09:45.857325	9f5068e6-4d97-4eb6-976e-82a471a4b09c
500	12	2024-04-09 09:09:48.525509	6461cd43-7581-473e-baf5-79dfd2f0554f
501	12	2024-04-09 09:17:19.046675	b75dab61-99dd-4943-a457-89a9f87142f0
502	12	2024-04-09 09:17:24.960926	d7bca81d-44ef-4f4a-9f2e-a52dd5f63d40
503	12	2024-04-09 09:21:33.045825	3942f4c4-159c-4526-803a-57ac71d680a5
504	12	2024-04-09 09:21:38.364366	3ac62c02-384d-49de-8efb-f6a870bcf5db
505	12	2024-04-09 09:22:18.560477	85fa134f-0fb2-4081-8032-7d86f200eda8
506	12	2024-04-09 09:22:23.922712	3f7b67f5-97c8-491e-9bc8-3d2aca7441c2
507	12	2024-04-09 09:43:17.23578	6a774798-4db8-4fa4-8ff1-c5aba991d659
508	12	2024-04-09 09:43:27.275352	96f61dbf-da8c-42e3-9f9d-e003c21b07e4
509	12	2024-04-09 09:43:30.706855	d17ca12e-f374-4bd5-b829-11a300de7941
510	12	2024-04-09 09:43:35.229253	60c0ce8b-7971-434b-ab81-0f82608e7b86
511	12	2024-04-09 09:43:37.928808	756cd19f-6595-454c-9ab9-41a6b251cc40
512	12	2024-04-09 09:43:46.399593	a9693445-79f0-4410-a95c-49e05acb70a8
513	12	2024-04-09 09:43:48.898054	a30bcf65-ce47-4e35-adcd-3db1aa71c1ef
514	12	2024-04-09 09:43:54.190423	7aee54cd-87cd-4584-9b28-dbc169ded696
515	12	2024-04-09 09:43:56.50778	6f422e79-ed12-4416-9297-4687955edc78
516	12	2024-04-09 09:43:59.790652	3ac07ff3-502a-46d1-a092-5d96445c8d3e
517	12	2024-04-09 09:44:02.1414	e4e7cb10-61fe-4de7-84e2-51e3d5a6b2a1
518	12	2024-04-09 09:44:09.650771	ab749363-ac6e-434c-b43f-0df89014f25d
519	12	2024-04-09 09:44:12.038996	f4caa0d9-9df7-4240-b3da-60ba1a76f054
520	12	2024-04-09 09:44:20.614213	8e7dae33-3f6c-4fb9-8d16-a64977a2c19c
521	12	2024-04-09 09:44:22.905149	fa37f17c-08cd-43c3-8fbd-42e6ceb28a03
522	12	2024-04-09 09:44:33.827625	63e82f8f-ab1a-48ac-93d7-8fac67ae03cc
523	12	2024-04-09 09:44:36.24698	eb821bb2-c7dd-439c-8f80-fa41c5ca7d11
524	12	2024-04-09 09:44:43.046265	aef2dc25-4ec5-43cd-8191-4c7ba85af531
525	12	2024-04-09 09:44:47.059076	b906a2cd-dc0d-420c-8b7d-0ce3b4703186
526	12	2024-04-09 09:45:02.641409	9d9a9e19-98d4-45b1-8c10-1bf9f61475a4
527	12	2024-04-09 09:45:07.298032	8d5cfe38-73d8-4a27-81a0-6417514429dc
528	12	2024-04-09 09:46:00.544162	38fa8dc8-ab17-4900-a920-6200221d7acf
529	12	2024-04-09 09:47:09.391398	87e3071a-303c-4901-951e-fc67e10d84b3
530	12	2024-04-09 09:47:18.63373	ddd844b3-5056-4fe3-a5c0-2f29a141721f
531	12	2024-04-09 10:25:27.391749	f16efe45-75f7-4506-b6fe-ef4abf879407
532	12	2024-04-09 10:25:37.311753	ffed576f-9f69-4c13-a010-23ff01400e65
533	12	2024-04-09 10:25:40.347798	01fec3c6-12fc-4557-9c6e-6d65742795af
534	12	2024-04-09 10:25:44.87436	9d27ad2e-0890-4c38-a623-898176c29a5b
535	12	2024-04-09 10:25:47.212401	b12e68bf-60e6-4ff1-9468-c4ca6d86beb1
536	12	2024-04-09 10:25:55.288398	796f3445-94de-444a-9e0e-890839a96376
537	12	2024-04-09 10:25:57.640933	e35985b6-d9e9-4f3e-ae01-2df4ad7ed1e9
538	12	2024-04-09 10:26:02.763	a1a94029-9d6b-4139-9200-448638ade5f4
539	12	2024-04-09 10:26:04.999088	7b54627c-63ee-47b0-811b-156bc2572700
540	12	2024-04-09 10:26:12.552856	0436e0da-046f-4001-8e50-352d3434e825
541	12	2024-04-09 10:26:14.944502	3d7739a1-30ae-4440-a064-e470008fa494
542	12	2024-04-09 10:26:22.255094	62d64bbf-8613-426d-868a-30cc441acf4a
543	12	2024-04-09 10:26:24.651052	39f8de20-97a2-4d1f-92fa-6207d220d45e
544	12	2024-04-09 10:26:32.595858	8eef8474-6e08-44b4-8cc6-5e41a360cf32
545	12	2024-04-09 10:26:34.893842	a0d6e9e7-d293-4056-8090-1d386dff8a79
546	12	2024-04-09 10:26:45.365622	255d13e1-77cb-479d-b18b-849661e6b4d8
547	12	2024-04-09 10:26:47.699639	73e37f2c-d361-43d5-b960-f93dc1797894
548	12	2024-04-09 10:26:55.24701	00f1ca7f-1332-43a1-ab79-f9b956c564a7
549	12	2024-04-09 10:26:59.279436	a23f8ca0-2c19-4a3f-b368-2e0529e9720d
550	12	2024-04-09 10:27:13.796967	9389f3c0-0446-4f1d-8e7a-d04b4a8bd105
551	12	2024-04-09 10:31:53.902767	9637a918-0f96-42cf-9a32-d665914fb3b9
552	12	2024-04-09 10:33:00.911953	f4f8e881-3a57-436e-aa51-d070c2b6f06f
553	12	2024-04-09 10:33:10.903897	31a32df5-61a4-4451-a3f7-b63a52993138
554	12	2024-04-09 10:34:06.403278	61eef478-23ad-4307-8b3f-5f4386175830
555	12	2024-04-09 10:34:15.912058	b2e9376e-acb2-408c-8dc1-3da033b914c6
556	12	2024-04-09 10:34:51.863914	19ae5aa7-4366-494c-bc23-11fb26131a5f
557	12	2024-04-09 10:35:01.42025	7a2ea560-c965-4db2-9504-6c464fc67458
558	12	2024-04-09 10:44:42.671467	f2011348-a168-42d1-8ef0-e0cb15c14442
559	12	2024-04-09 10:44:52.17477	ce55d21a-257b-436d-bd1a-10347ddd1904
560	12	2024-04-09 10:44:55.063213	5e101797-e921-42a3-8d20-67804c0ff808
561	12	2024-04-09 10:44:57.193123	477fb3d1-4a88-4e5d-a54e-4dab5e949cee
562	12	2024-04-09 10:44:59.459421	06919401-7e98-4258-8e35-f2744fab5392
563	12	2024-04-09 10:45:07.707681	5f76a843-9c0c-486d-8ead-15c09e3c57a8
564	12	2024-04-09 10:45:10.06432	b896aabd-0093-4e0b-b67b-963df45c6c63
565	12	2024-04-09 10:45:12.721344	78166f84-8600-4d62-ace3-5c3d7063207c
566	12	2024-04-09 10:45:14.932674	b2c1a7dd-21f5-46e2-bba7-187e2914fa02
568	12	2024-04-09 10:45:24.612283	a1395070-da20-43e5-ad78-96e1ede55cef
567	12	2024-04-09 10:45:22.372034	b32ec8c5-225a-406b-9754-f9d164a53bb2
569	12	2024-04-09 10:45:31.64947	0f34e154-6d1b-4305-8b6a-a462490ad12a
570	12	2024-04-09 10:45:34.15736	17e0c52d-6af8-4e89-8e42-4f81d05b509b
571	12	2024-04-09 10:45:43.017102	cba5ba8c-5129-4b97-b26c-b23e47f4fafe
572	12	2024-04-09 10:45:45.323843	00a776f0-6519-4276-84c9-c2361c91128c
573	12	2024-04-09 10:45:50.392521	4ebd86ea-cee4-42fe-9bf6-8b97d4c753fe
574	12	2024-04-09 10:45:52.679224	fa95171d-4d3a-449d-a249-66573f6980c0
575	12	2024-04-09 10:45:59.325094	26609529-beea-4ee7-9b84-a6a25af8ef35
576	12	2024-04-09 10:46:03.631133	1a331edc-3a14-4e25-8b6f-e5799bd23c6b
577	12	2024-04-09 10:46:46.219799	6aca6193-3a19-492e-b25b-93768e6f269e
578	12	2024-04-09 10:46:51.936923	13529bbc-be1e-49db-a1cb-963f4ae4e320
579	12	2024-04-09 10:47:41.049627	af89dbc3-5fd8-499a-ad3a-fc680a2e0b07
580	12	2024-04-09 10:47:51.016033	a5dde2e1-4066-4323-be8d-982543e503eb
581	12	2024-04-09 10:47:54.010042	c38ea6cf-e8d1-4a57-a1d1-ef3c12b813da
582	12	2024-04-09 10:47:58.727643	6330a31a-122c-4f06-a218-316b699cc32f
583	12	2024-04-09 10:48:01.144429	6379f7ff-ea38-44f4-a066-df22f9998242
584	12	2024-04-09 10:48:10.080523	eab60c3d-4c8b-4446-82b9-4ec0ee530d84
585	12	2024-04-09 10:48:12.516669	0d34995f-033e-4a94-9ea4-9ab3a28cdafe
586	12	2024-04-09 10:48:18.406407	dbe0a7ee-2d82-48fe-aebb-589a4cef3f07
587	12	2024-04-09 10:48:20.625566	66df5111-e577-4bc8-bb11-d1c45883b5a5
588	12	2024-04-09 10:48:28.689364	a6cd45bd-68aa-4f4e-b527-14e012276904
589	12	2024-04-09 10:48:31.050564	6b31b217-ebc8-46a9-81b4-46e5a6edbf08
590	12	2024-04-09 10:48:38.372377	c070e66d-9124-4618-92cb-b95cc3adaafd
591	12	2024-04-09 10:48:40.640304	6e2bfab3-9091-42de-8749-8ea8b0b5e9b2
592	12	2024-04-09 10:48:48.395377	bcd53aa3-838b-4ab9-a3d0-2972625c971d
593	12	2024-04-09 10:48:50.701322	fc6a0762-a6e4-49d5-b177-0a2d183f7ff4
594	12	2024-04-09 10:49:00.842416	a3e209ce-501b-4d5e-b5cb-e4577d31fa20
595	12	2024-04-09 10:49:03.23195	6e9eb999-dd9f-4447-ae07-e77c5e3390fb
596	12	2024-04-09 10:49:09.855102	bad8178b-0f88-42c8-9ba5-e8073fbd0539
597	12	2024-04-09 10:49:15.630679	8d278438-bde7-4b19-be71-9f6dc8318d74
598	12	2024-04-09 11:00:52.484417	42e692a1-b3d4-471d-afd1-70b3c4104fbb
599	12	2024-04-09 11:01:02.045032	82235183-0ed8-471c-8c7b-0d77490e69cf
600	12	2024-04-09 11:01:05.061891	6bffd14d-f86c-4061-8722-a0bc39db5209
601	12	2024-04-09 11:01:09.79348	1204c77f-4e21-4160-b4ae-b1ac4b1f707b
602	12	2024-04-09 11:01:12.190768	1a4e90d4-4dbd-478b-bc01-5853c17e3707
603	12	2024-04-09 11:01:20.352712	5d0e5af9-1900-4dca-88f7-7759320e4df7
604	12	2024-04-09 11:01:22.642774	e3305850-0fe5-4d3b-a78f-b25405b3a821
605	12	2024-04-09 11:01:27.821199	9c7a16cc-49fb-490c-9c4a-8506cf7e2bf5
606	12	2024-04-09 11:01:30.03909	6b60f304-10b1-43e4-85f6-854c96bce9ca
607	12	2024-04-09 11:01:37.226628	ff8e4496-8cfb-4268-9d96-d97d3b1461a9
608	12	2024-04-09 11:01:39.498145	8ac2dafc-f208-4afe-a126-cf50c55674f2
609	12	2024-04-09 11:01:46.870731	2b103c7d-e42e-4ab3-90ac-8a2f3171c99a
610	12	2024-04-09 11:01:49.192744	b63626f3-31ce-4386-bebd-5f030b276a5e
611	12	2024-04-09 11:01:57.088115	38e3272f-c90d-4347-816b-dab4bdf6c00f
612	12	2024-04-09 11:01:59.312362	9f28685e-c139-4874-8e42-f4297dc28fbe
613	12	2024-04-09 11:02:09.444099	a4d95126-94cb-4f06-8115-b1c9ab0fd9e5
614	12	2024-04-09 11:02:11.714083	7fd5eaa5-e80f-4a02-9ef9-856524f5ed4c
615	12	2024-04-09 11:02:18.537936	77503cb2-4cec-46df-aa57-0f7b6ab50d9d
616	12	2024-04-09 11:02:22.671891	6a76ec78-f3ad-474a-9a8b-100476d0d997
617	12	2024-04-09 11:11:37.397404	8e86e21d-6ee9-4adc-b893-a6f3effae088
618	12	2024-04-09 11:11:49.087272	8c74926d-a0c2-43ce-9cc0-0bf316d1b444
619	12	2024-04-09 11:11:52.157568	7dbbd971-4906-4c45-a339-fa3e11971325
620	12	2024-04-09 11:11:57.80167	acd95747-c086-427b-be88-4f98ace40006
621	12	2024-04-09 11:12:00.431264	b3b8631b-3df3-455e-8775-b05e7c17f5c9
622	12	2024-04-09 11:12:10.97826	bc9a4bc4-21d7-4c4b-8a55-c092e2e48910
623	12	2024-04-09 11:12:13.235859	034d9950-3e00-49d4-b84a-7c53717ac52e
624	12	2024-04-09 11:12:36.376399	08d6fbd8-a126-4648-b5e1-d06cf7116217
625	12	2024-04-09 11:12:38.660759	2fa5cc2c-bc8a-4ab5-be30-53d4a910370a
626	12	2024-04-09 11:12:46.369533	d0598e3e-cf79-4623-aa63-a96047dd6739
627	12	2024-04-09 11:12:48.68996	ed8d9e92-1d6e-4fb7-a7e4-6301e19d1832
628	12	2024-04-09 11:12:56.416912	e70f0f37-ad88-40d6-9b3a-229726779957
629	12	2024-04-09 11:12:58.719633	55e5d0cc-dde1-4ac9-b418-53cc2bca2ad8
630	12	2024-04-09 11:13:06.531318	7294d1d5-fca4-4501-a835-fc605530be14
631	12	2024-04-09 11:13:08.88427	60428dbd-4f48-411b-9060-672e5d8e23f8
632	12	2024-04-09 11:13:19.341609	47fc4c28-e5f3-4bc6-944b-b487a2c43e97
633	12	2024-04-09 11:13:21.693357	949c9fc3-9be3-43e7-9ce3-da9407153504
634	12	2024-04-09 11:13:28.251496	1119fa10-8f63-4e9a-b626-4936311a63b9
635	12	2024-04-09 11:13:32.372642	a6892238-0477-4aba-a984-28cfe085d42c
636	12	2024-04-09 11:35:47.314786	29815fa1-d8a6-4876-bd8e-16f5dc4958cd
637	12	2024-04-09 11:35:57.502518	ae853cdf-6149-45d1-a094-cfb2eeb10794
638	12	2024-04-09 11:36:00.6765	adb308a8-cc75-4dbc-beec-1177f64b893a
639	12	2024-04-09 11:36:05.228401	f12e800e-b2b7-4a03-b59a-0cedaa8d8c20
640	12	2024-04-09 11:36:07.669741	eb52e666-5195-4ace-909c-048180207c6d
641	12	2024-04-09 11:36:15.752542	7cdfb205-8531-4430-b4f4-5e7a2bb854de
642	12	2024-04-09 11:36:17.953453	ed4a31bb-5139-4582-bd9a-4445f76785bd
643	12	2024-04-09 11:36:23.034721	8a828a36-ef32-4aad-ba73-2b3043d427f7
644	12	2024-04-09 11:36:25.270552	731c4a91-bdc5-48e4-8535-0d04c65fa6d1
645	12	2024-04-09 11:36:32.646793	1ab9d2e5-072f-4020-8b1c-15538634fe35
646	12	2024-04-09 11:36:35.227861	22ae8251-a87b-429b-a2dc-fd403ce776d2
647	12	2024-04-09 11:36:42.512559	15eb27f8-168d-4001-8552-7b3d1f38b481
648	12	2024-04-09 11:36:44.915126	55cb5932-449d-4a7d-8671-28c23d267bff
649	12	2024-04-09 11:36:52.894817	6fdb7990-a3b1-43cc-b3ca-e308e79b8aac
650	12	2024-04-09 11:36:55.273533	75ecdec4-b397-410c-bd3b-cfe607956916
651	12	2024-04-09 11:37:05.936417	105b07db-31cc-4aaa-bfdb-29df8828ccde
652	12	2024-04-09 11:37:08.352	fa36f495-47fd-479c-afda-39d70659ee62
653	12	2024-04-09 11:37:15.133284	ef8001b8-1729-4986-8dc5-44a7caba6ae9
654	12	2024-04-09 11:38:57.137478	02171d4b-5d73-40d8-bd41-22d503af62cb
655	12	2024-04-09 11:39:05.943657	93292a8c-e303-4f6c-b4d7-00d0c8cbda05
656	12	2024-04-09 11:39:11.175112	a6498b00-7a02-4c6a-8c48-cd0668324f2e
657	12	2024-04-09 11:41:18.078577	b1e31959-6fcb-4851-b695-78b750cb881f
658	12	2024-04-09 11:41:22.700564	da54337c-6195-4754-922a-1a8d2857ac98
659	12	2024-04-09 11:41:24.179528	ca90058f-cb98-4b0c-8c14-3dcd45c82df4
660	12	2024-04-09 11:41:26.128213	767a9446-5b18-4f05-a681-7c9cae6bce9e
661	12	2024-04-09 11:41:27.154418	bae38ff8-cc77-41e7-9512-5f0eb625404b
662	12	2024-04-09 11:41:30.545523	20fd3f41-f05c-479e-8aa9-74ab3f319ffa
663	12	2024-04-09 11:41:31.531347	3d8de21b-a6ad-456c-81e2-ff3d372e71cb
664	12	2024-04-09 11:41:33.689849	333eaba0-ab60-4b0e-9cc1-a2f3c16d7328
665	12	2024-04-09 11:41:34.703766	e8be23e9-7579-42c6-be1c-a4efe5b53d1b
666	12	2024-04-09 11:41:37.774318	57e4d290-559c-4b41-8bec-b93c10e97945
667	12	2024-04-09 11:41:38.784284	214771d3-75fe-450b-b749-2d11f3ec6a1e
668	12	2024-04-09 11:41:41.846449	4ee56051-70f9-4cdf-a2f7-84bf2995e1b9
669	12	2024-04-09 11:41:42.839379	253dabe1-e928-43cd-af3b-25f6ff854eb0
670	12	2024-04-09 11:41:46.082861	8c4e8266-6b9e-46d6-912e-da46d2666622
671	12	2024-04-09 11:41:47.076934	af03e065-fda1-4b74-93cd-7fd26c271279
672	12	2024-04-09 11:41:51.283654	b9a60cb1-4301-4d96-a9ba-807ee83a6f50
673	12	2024-04-09 11:41:52.288704	e931075c-baa2-43dc-9635-271973c60942
674	12	2024-04-09 11:41:54.952465	32323c4c-26e7-479e-8449-8361f0de6e45
675	12	2024-04-09 11:41:56.623793	329188f6-c93e-4f1d-ad05-385b8909c835
676	12	2024-04-09 11:41:57.682934	68254326-83c8-496f-af81-3b9e09098539
677	12	2024-04-09 11:41:59.159836	0d995bd9-9de6-409c-9bc0-d3813b50bc44
678	12	2024-04-09 12:03:27.453705	6de03ead-f9e8-46c1-be1e-d3214216f732
680	12	2024-04-09 12:03:35.98471	6477a4a0-ad35-49f2-954e-2dd2bac5ca06
679	12	2024-04-09 12:03:35.115453	814e71c1-68d6-483a-936d-b99e7105814e
681	12	2024-04-09 12:03:37.947467	92f8b391-0f9f-4b56-9502-aef5e5932afc
682	12	2024-04-09 12:03:38.974541	7981836b-9486-4114-9dfa-dd548035cafc
683	12	2024-04-09 12:03:40.0098	40463a84-9fac-4587-9b30-0a2c5c54adee
684	12	2024-04-09 12:03:41.408625	93889d7f-8eb8-41ee-be58-8bac8a844020
685	12	2024-04-09 12:03:44.812675	0688d9e7-e2d1-430e-b444-0c224513f3eb
686	12	2024-04-09 12:03:45.638357	3082fcc6-1755-42a4-81d0-9e314ddb2440
687	12	2024-04-09 12:03:46.296177	c639a374-dbe4-4632-8cdd-5de79b27f9da
688	12	2024-04-09 12:03:47.65246	7a506ac7-9412-4fc1-88bc-ffc7a1ff73e3
692	12	2024-04-09 12:03:50.438424	6d19b196-48eb-4411-8412-946324f15aac
693	12	2024-04-09 12:03:51.484515	22ae0c59-1503-45ed-8196-fbd3562166f3
696	12	2024-04-09 12:03:55.067749	f1a67282-270d-4b84-b610-2b48c69ea7c1
697	12	2024-04-09 12:03:56.387795	7a26e55a-2e93-4e97-8d31-d7f14a874d6e
704	12	2024-04-09 12:04:03.195475	96878108-df6a-4b3d-9f31-019adbb3ef57
705	12	2024-04-09 12:07:52.021121	5f2d9b0c-7722-4a3e-921c-91abfc74fab9
689	12	2024-04-09 12:03:47.91647	dbede1b4-5b42-45a0-b2ff-7902c883c711
690	12	2024-04-09 12:03:49.098044	48db97b6-600f-4dcd-b405-c981d3c34ba0
691	12	2024-04-09 12:03:50.344308	b43b7a82-7814-48d3-a146-9d202a2d266f
694	12	2024-04-09 12:03:52.783839	fe625eb1-c2e5-42a5-86cd-ae9db519d3ed
695	12	2024-04-09 12:03:54.078848	9f68570b-9636-4ac2-b5b8-81c5ddfda8da
698	12	2024-04-09 12:03:56.952445	502057d6-cbda-4059-9f51-c3ab3453ec9f
699	12	2024-04-09 12:03:57.576398	76538167-3948-4c48-8ccd-f6fec9ce0638
700	12	2024-04-09 12:03:58.780406	df5e4a4b-6227-4d9a-8fb9-2c8c8da366fe
701	12	2024-04-09 12:03:59.019155	8f32ece9-0937-4c3b-ad27-aa19bbdc99b5
702	12	2024-04-09 12:03:59.866999	c9d625b9-dc99-42f3-96c2-4ef1618efeb4
703	12	2024-04-09 12:04:01.231245	be8a006e-90d7-44d6-b72c-de27e2626ef2
706	12	2024-04-09 12:08:01.556515	ccbc687c-ff06-4636-b8ff-ff0569ab5e45
707	12	2024-04-09 12:08:04.537075	e88a4304-3f54-45b9-91ad-8a632c76dcbc
708	12	2024-04-09 12:08:08.912388	9fad6c96-52d4-4d82-a74b-85d94845b866
709	12	2024-04-09 12:08:11.159942	b1d4c664-df91-4e01-9d81-3ab859de4775
710	12	2024-04-09 12:08:19.544595	34383b48-a563-479d-b974-e776dfeb55c6
711	12	2024-04-09 12:08:21.794734	7ead9ca5-4c26-4d16-92c2-9c60946849b3
712	12	2024-04-09 12:08:26.786885	0dbcb129-e051-48a2-9f7c-862d32c13465
713	12	2024-04-09 12:08:29.004117	390c38d8-c6f3-4420-88cd-814c71787c6a
714	12	2024-04-09 12:08:36.848815	e844f957-31b3-46cd-b77f-edb657cbe5f7
715	12	2024-04-09 12:08:39.241459	4bfe3b64-1aee-43f8-abf6-b471668e6bfd
716	12	2024-04-09 12:08:46.9433	8db3ef10-84f9-4aa0-a430-7a9204396382
717	12	2024-04-09 12:08:49.336232	f3e24001-05ee-4240-8d05-25a4c318954f
718	12	2024-04-09 12:08:57.353451	9062b542-72aa-487c-8067-7b138632b3fe
719	12	2024-04-09 12:08:59.696929	6c3444cf-8601-4c67-b4ec-7276995454cc
720	12	2024-04-09 12:09:10.308555	bd545cd3-4df0-494a-8e7f-36635e9e7f19
721	12	2024-04-09 12:09:12.60985	811d8bfd-a8cf-4c86-827b-24968ee42a1e
722	12	2024-04-09 12:09:20.897085	f9ba72c1-971b-4832-a029-93f9f87ba606
723	12	2024-04-09 12:09:25.498131	3b27a694-953e-46a6-872c-f4b798e2095b
724	12	2024-04-09 12:09:27.956066	1eeee7bb-0ecb-40da-bfea-42b0dddd0363
725	12	2024-04-09 12:09:31.874889	7d1a8994-30fb-4dc6-a04c-39d8f8f2476c
726	12	2024-04-09 12:12:24.321214	354b6fd6-0d6d-4b2b-baa6-fd13c1f5a76a
727	12	2024-04-09 12:12:33.908656	6d8f9d9c-157f-41cb-ba13-c37e8513b1f9
728	12	2024-04-09 12:12:36.902976	c037bbab-2119-4290-9915-b0a2d99e28c5
729	12	2024-04-09 12:12:41.325037	82409d90-a07d-4619-96ce-361b5d834108
730	12	2024-04-09 12:12:43.711903	18c59ebe-3dec-40df-8743-9e2d06d09148
731	12	2024-04-09 12:12:51.871615	a4c54cdf-d732-4467-b80c-8ef1d48dd4b9
732	12	2024-04-09 12:12:54.511363	eb47c46b-e97a-4011-96bc-8067bbc564c3
733	12	2024-04-09 12:12:59.88161	3193bd86-8bd8-4a4f-adf9-3005ec5c72ee
734	12	2024-04-09 12:13:02.184608	144e3119-d0ca-4495-8789-11ab2acc9db3
735	12	2024-04-09 12:13:09.833293	39878cec-81e6-4595-aacd-13fcaf06e089
736	12	2024-04-09 12:13:12.180526	439948c7-96d4-4651-9942-9a2f00b3f754
737	12	2024-04-09 12:13:20.364304	41ad0b52-aeef-4c8b-94cf-0eaa27663fac
738	12	2024-04-09 12:13:23.340543	ba67a396-4c4c-470b-a0fb-e43f32a59d15
739	12	2024-04-09 12:13:32.256635	e4c8936e-f9b5-4d9e-acb3-fc2a2aedc33a
740	12	2024-04-09 12:13:34.539014	f1762ad0-a7b9-4cef-971d-bcab06a59932
741	12	2024-04-09 12:13:45.06083	7418263d-7a80-4b23-9b4b-cb4d661bcd27
742	12	2024-04-09 12:13:47.478208	83c53e98-ee98-4478-81e1-83b08bfec737
743	12	2024-04-09 12:13:54.796443	cc4f3c03-7aa2-4098-b520-f476bf43842c
744	12	2024-04-09 12:13:59.141551	10f18369-5f96-4e1d-ba6f-59cef4c2fbe8
745	12	2024-04-09 12:14:01.699893	9298c1d1-cfc6-4880-92ee-ad7db4c242ad
746	12	2024-04-09 12:14:05.599208	f7afa4bb-c632-4a5e-b48c-4ca58ec62d9d
747	12	2024-04-09 12:18:07.476436	b3aa93ca-907c-44d3-88e0-663a119a8c0c
748	12	2024-04-09 12:18:12.368543	f6ebd171-4fa5-4b71-9ecf-270d3d878c71
749	12	2024-04-09 12:18:13.976701	c633d0be-a7e2-4f1a-9621-6f0bdb2ae6fd
750	12	2024-04-09 12:18:16.015576	e55420ec-aa58-4d77-91ac-42737bd39cb3
751	12	2024-04-09 12:18:17.064593	fe2eeb0b-cae6-4ada-807b-1da4d33daca4
752	12	2024-04-09 12:18:20.684685	5e696754-fc56-4ff0-95c8-5d374c71d68e
753	12	2024-04-09 12:18:21.753135	53d8997c-7695-47d4-91de-00a0385b4648
754	12	2024-04-09 12:18:24.071829	c3b8193a-c0f7-430f-803c-8199b65160c8
755	12	2024-04-09 12:18:25.109916	7c46aac6-99ea-44aa-916d-ba508731eaf5
756	12	2024-04-09 12:18:28.376869	3a101171-1a7f-480c-b80e-ff55877f9666
757	12	2024-04-09 12:18:29.449461	d82dd29a-68b8-43ed-a301-e2fae84ddf4c
758	12	2024-04-09 12:18:32.674896	5850cce5-e9d8-4203-81d0-848d35b4c0a2
759	12	2024-04-09 12:18:33.719414	5baf8f55-f8e7-45ab-b8a6-65c421ade07a
760	12	2024-04-09 12:18:37.204519	b15e0bc6-f2cc-47c1-ae11-b0881b833cc1
761	12	2024-04-09 12:18:38.262395	1a8591a7-376b-4972-8255-35f9c05be513
762	12	2024-04-09 12:18:42.752977	34369362-0d6d-4c59-b337-f5b1f4c6fa2e
763	12	2024-04-09 12:18:43.809898	e2cd54ef-6098-4224-9417-ccc38a8af24b
764	12	2024-04-09 12:18:46.640893	b59a1546-5a51-454d-a4ce-1092e5ebacb9
765	12	2024-04-09 12:18:48.448363	be2edc78-2db1-4051-945e-963f5fecb151
766	12	2024-04-09 12:18:49.573315	c9c8bb73-98b1-459f-93f6-74776f522d37
767	12	2024-04-09 12:18:51.220423	d10d871c-ce50-4f29-8624-54dd4059078d
768	12	2024-04-09 12:19:51.71632	b85c5435-cf4b-4da3-ab3a-062b1547cd57
769	12	2024-04-09 12:19:56.852576	85d200a3-e0e2-4067-b911-9b3861ecc22a
770	12	2024-04-09 12:19:58.580584	b96d9855-2c9a-4792-b03f-35eb4cee7e30
771	12	2024-04-09 12:20:00.9071	751b9eb3-01f2-4735-82a1-440a456b28ae
772	12	2024-04-09 12:20:02.182139	9b5cbe2f-d980-4a69-b776-d6c84e16b3fd
773	12	2024-04-09 12:20:06.531999	d420d260-8101-4e65-b64e-926627a0fe31
774	12	2024-04-09 12:20:07.750025	729f8c9a-ff53-4ca5-ad1d-3cdd3387102d
775	12	2024-04-09 12:20:10.35095	60b77a8b-04c2-4f9c-9503-58f3c914ac67
776	12	2024-04-09 12:20:11.523121	cee91071-6ff4-4464-8f31-f44db85896cc
777	12	2024-04-09 12:20:15.247469	fdc26d2a-79fe-4ea2-aa89-b233e09d519a
778	12	2024-04-09 12:20:16.412867	6f7a785d-b3c4-491b-9821-ae0b70c1793c
779	12	2024-04-09 12:20:20.081871	8bb992bc-c136-46ff-b208-4ddb3592dfd3
780	12	2024-04-09 12:20:21.273736	e663bec9-e144-4592-b98a-3dba9f978407
781	12	2024-04-09 12:20:25.268995	cb9ae7a9-eec7-4b4e-b0fd-bc9f974c688f
782	12	2024-04-09 12:20:26.4432	f85eee7a-d810-439b-8ec3-47c784a6b89a
783	12	2024-04-09 12:20:31.459113	def44aaa-61d5-4d10-9b03-86eee243244a
784	12	2024-04-09 12:20:32.624993	d30c79b4-672e-4108-b592-7e257c64715e
785	12	2024-04-09 12:20:35.878158	e6e6ef7b-171b-4c6f-9035-4e7baed7a27c
786	12	2024-04-09 12:20:37.98287	ce265b2d-a899-45bd-8675-24bdbf1f5574
787	12	2024-04-09 12:20:39.193582	d32cd630-b65f-406e-9992-50d88147e125
788	12	2024-04-09 12:20:40.996562	6ea3bf3c-bddd-477b-828a-e482724e994e
789	12	2024-04-10 02:26:07.080756	d80d5052-0e89-404a-905f-c442ccaffdc6
790	12	2024-04-10 02:26:12.20234	0c158117-ffc0-4836-b16a-7051afeadc82
791	12	2024-04-10 02:26:13.841972	30f4b500-c3ce-4953-8d33-6385e3bd2253
792	12	2024-04-10 02:26:15.89237	d421f4d9-e032-4353-96f6-b9b2feacb31c
793	12	2024-04-10 02:26:16.962565	ba704a34-95f1-4950-addd-3fedb6426276
794	12	2024-04-10 02:26:20.547592	9dd57386-9b4b-45c0-87cf-bf58494b53b6
795	12	2024-04-10 02:26:21.632359	cb5e38b6-ed77-482b-9f08-f9838ad1abe6
796	12	2024-04-10 02:26:23.948551	0d5064fa-6ac4-4265-a0c8-af399c9b8abc
797	12	2024-04-10 02:26:25.076425	c0072dec-ecaf-4814-9d20-c34f418e8bd7
798	12	2024-04-10 02:26:28.278264	fc277ac1-dd43-4e2b-ab90-887ad150f8a3
799	12	2024-04-10 02:26:29.316949	3d15c789-0ca2-49e9-856a-7b10be8f5c43
800	12	2024-04-10 02:26:32.534904	7eb4bde8-04eb-4b64-933f-cd70c5fc20ca
801	12	2024-04-10 02:26:33.584304	65461f9d-06ea-4272-b4e3-0c7ea0929b23
802	12	2024-04-10 02:26:37.103229	5f5a5304-889d-4bbb-8690-a148b94736b8
803	12	2024-04-10 02:26:38.171356	48b9c98a-cd2b-4b6b-9f3d-0421b95d92f7
804	12	2024-04-10 02:26:42.648521	eefb50d7-2bfa-49eb-a17b-f7909b7d4fbb
805	12	2024-04-10 02:26:43.742357	98255c1e-4b83-4ad3-9079-d7363b9e0114
807	12	2024-04-10 02:26:48.290783	8bb7164b-6441-4d89-96b6-f3551c585b95
806	12	2024-04-10 02:26:46.523449	0a61424c-b64b-48e4-9d8b-2185663df185
808	12	2024-04-10 02:26:49.326847	76891168-ae55-40da-b285-63b87784d617
809	12	2024-04-10 02:26:50.894149	8c7df1e1-91d8-4091-a2b4-c2382b0aa6a5
810	12	2024-04-10 10:50:19.147744	6e6e3d3c-de93-471a-b4f3-300b91c026f2
811	12	2024-04-10 10:50:24.78059	2b638551-58a8-4de9-90f1-265ef99d09b9
812	12	2024-04-10 10:56:33.955731	b00da225-6e9d-4e8c-a5c8-4bb6b0bc721d
813	12	2024-04-10 10:56:38.697598	aeaae647-b636-4a42-900e-01194e22d8f0
814	12	2024-04-10 10:56:40.113374	e4b17335-7d05-4d42-8bc2-d6c81644a9ab
815	12	2024-04-10 10:56:42.066093	870f2d52-2b9b-4edc-9f0a-1a6799230c02
816	12	2024-04-10 10:56:43.071888	208978a6-6137-4f97-b9f3-fe35afc05513
817	12	2024-04-10 10:56:46.604838	7d77e688-3abd-405e-9b78-765a10dd33e1
818	12	2024-04-10 10:56:47.652282	e9938d18-be21-49cd-b6ea-861467ffcf09
819	12	2024-04-10 10:56:49.938599	64bfae2f-2c5a-47be-bdec-37db312516a6
820	12	2024-04-10 10:56:50.956274	da5d7681-e75b-4a2f-8332-950c3bab8d9d
821	12	2024-04-10 10:56:54.04194	5cd61eeb-56b3-4870-ab6f-0e7f7fe23ea9
822	12	2024-04-10 10:56:55.048868	37e2de37-82c3-4b33-a85a-37c15d670b11
823	12	2024-04-10 10:56:58.149984	a9d30458-b561-40a2-82ab-6e1548a30b06
824	12	2024-04-10 10:56:59.14362	71d16eb5-553d-413f-a324-b0ea40dd13dd
825	12	2024-04-10 10:57:02.514537	cfa88909-72a2-4238-9134-e02a0bebd11e
826	12	2024-04-10 10:57:03.532839	eacec313-a149-4f28-98af-6d2a18d2b528
827	12	2024-04-10 10:57:07.890032	e4b87134-af4a-41b5-b9e0-2bde99652e96
828	12	2024-04-10 10:57:08.889383	03287b9c-52ad-45eb-80d4-0f49ca1e8cc8
829	12	2024-04-10 10:57:11.62742	dbb7d429-db49-4158-a309-da335b18db80
830	12	2024-04-10 10:57:13.337901	717d865a-cdad-4528-a075-1699440a0f15
831	12	2024-04-10 10:57:14.362685	46df4356-0caf-4819-9440-e3330a91a532
832	12	2024-04-10 10:57:15.855394	4411f046-c392-4747-ab7c-55349172de26
833	12	2024-04-10 11:00:05.436441	00864092-012a-44e0-a56e-c4303c8ce0d4
834	12	2024-04-10 11:00:10.273722	43118ef6-eee3-4e8d-994b-91dbe88462c1
835	12	2024-04-10 11:00:11.878712	c2061a1a-02ca-4f00-b081-8ff89d0cffa5
836	12	2024-04-10 11:00:13.918084	97e764cc-d555-4e72-be9e-17db4dbd847d
837	12	2024-04-10 11:00:14.980498	bf0cbea8-6707-4447-a21a-6ed3326474b3
838	12	2024-04-10 11:00:18.648534	564c2cba-f168-4b4b-a338-d52582524cac
839	12	2024-04-10 11:00:19.714944	295cf153-afb4-45c3-8b44-fb894a794d0d
840	12	2024-04-10 11:00:22.111023	7242f518-5414-4655-aba2-ebe7faa7f913
841	12	2024-04-10 11:00:23.200299	a6c312a1-72ab-49c5-8d00-f97c325cfc36
842	12	2024-04-10 11:00:26.560481	41c265ce-598f-4223-be6f-6a5fe374ce07
843	12	2024-04-10 11:00:27.655438	3b98a125-9ee4-40ab-aac8-3d03980ebc90
844	12	2024-04-10 11:00:30.892895	e9c8f59b-5eb3-43d2-b7aa-eb7c5d108090
845	12	2024-04-10 11:00:31.945963	ed200be2-084a-4c8f-98d9-c6df7b2905ac
846	12	2024-04-10 11:00:35.453132	6bce9cc9-bfa7-4b35-8c5d-5234d1e844b1
847	12	2024-04-10 11:00:36.496669	ab859e9a-08db-4e41-88d9-786868c054e2
848	12	2024-04-10 11:00:40.882239	4d622b1b-74ce-4dd3-9a32-a7265c148164
849	12	2024-04-10 11:00:41.934941	de3a1b93-a6da-445c-9737-8a77337daa90
850	12	2024-04-10 11:00:44.934765	6626f02b-e3b4-4c1b-8d67-d1e79f85e706
851	12	2024-04-10 11:00:46.739645	db92326a-84f5-4c09-9a01-80607bdf1518
852	12	2024-04-10 11:00:47.792187	8a6e1bd8-31a6-4326-9fbd-938b7bfd3f44
853	12	2024-04-10 11:00:49.377713	721ab552-33f5-4d79-aa76-4e39d894a91f
854	12	2024-04-10 11:01:19.710918	75220537-e33a-4715-a541-fde320ba2359
855	12	2024-04-10 11:01:24.473023	1f521483-27b3-457e-8310-b9445a180f90
856	12	2024-04-10 11:01:26.046412	3455da8d-cab6-4c60-84f2-92652fd85027
857	12	2024-04-10 11:01:28.115803	b2c473cf-6d46-4621-847a-7b948255bc5e
858	12	2024-04-10 11:01:29.167104	127c72a6-6247-491a-b453-586bedeb1b33
859	12	2024-04-10 11:01:32.767588	1e2717db-8edd-410d-8764-a432199246d9
860	12	2024-04-10 11:01:33.796848	4d18293e-9749-4aef-9d97-b1eb2661ade7
861	12	2024-04-10 11:01:36.077198	28023066-c999-4880-b874-7dc29134d939
862	12	2024-04-10 11:01:37.148299	0444b664-7ea5-4068-bc43-cac5918ecebe
863	12	2024-04-10 11:01:40.361427	b6947ab9-ecf4-4164-b409-cfbf5b3ce9b1
864	12	2024-04-10 11:01:41.403554	506704f3-4f30-40b1-84d3-9ea6c2e2c822
865	12	2024-04-10 11:01:44.622078	6bd1056a-72a2-4cfe-b820-c7cb2fd8cf39
866	12	2024-04-10 11:01:45.645075	b92bce03-17ab-4c69-a997-dadce07905a2
867	12	2024-04-10 11:01:49.07087	2ac73f2d-d935-4252-a44b-a8b4ed8434f5
868	12	2024-04-10 11:01:50.116912	9cbdb01d-9056-4cbe-b439-add5a7160a89
869	12	2024-04-10 11:01:54.412063	62f4ac4c-f52d-4280-af94-4f62e5d21510
870	12	2024-04-10 11:01:55.420621	c83ed485-1db8-463a-a2ed-d77e34a85d71
871	12	2024-04-10 11:01:58.182816	587661cf-c8e3-4e47-ab0a-311ba6d0d531
872	12	2024-04-10 11:01:59.990867	3e4305ef-20ec-43b2-82e0-ee7365b58e44
873	12	2024-04-10 11:02:01.103396	0e927e1f-6be6-40a8-9124-f78315d8e5a7
874	12	2024-04-10 11:02:02.729268	5e6e84f5-ee87-428b-ae59-c5dc28bd900f
875	12	2024-04-10 11:05:57.22601	4a3a4dd5-aa15-4623-bd64-609acc88d0f0
876	12	2024-04-10 11:06:02.252504	8102c7c7-665e-43f7-b0a7-858d41170d0c
877	12	2024-04-10 11:06:03.930597	809c7756-2a83-4fed-ba44-dbe8c3597460
878	12	2024-04-10 11:06:06.178796	8ca59f2c-acad-4d61-a2b5-e36e5d60c443
879	12	2024-04-10 11:06:07.371679	732c41db-e969-4f50-b856-0b546a735eb8
880	12	2024-04-10 11:06:11.405807	fbe95784-4d31-4b22-9aab-44889a741192
881	12	2024-04-10 11:06:12.598679	66a2d63a-4c3b-40ab-8056-0d56c2fcbdd3
882	12	2024-04-10 11:06:15.16509	2ca23e5b-a792-4d48-848d-747bee11e009
883	12	2024-04-10 11:06:16.317299	ae2bfde1-f782-486c-8bdb-49f11c0ad79a
884	12	2024-04-10 11:06:19.940763	9650484a-85ae-4434-862a-d7e1e34a311e
885	12	2024-04-10 11:06:21.104296	4b8b892e-5a57-4cfd-81a6-505918c1474a
886	12	2024-04-10 11:06:24.808591	8aa3f07a-a7ba-4d8a-85a9-ccff2393740b
887	12	2024-04-10 11:06:25.988209	cb1f1db7-5d9f-43ab-80da-884138a064f7
888	12	2024-04-10 11:06:29.948479	bba638c9-4c48-4089-bd41-6b6e519cab80
889	12	2024-04-10 11:06:31.136087	52d053d1-df9e-46ee-b8a9-0618ee9af967
890	12	2024-04-10 11:06:36.288546	1b87a0f1-c3a4-4e4a-87f9-7a6f2dd220be
891	12	2024-04-10 11:06:37.450243	237c19b7-cda6-41df-a587-b77eb0a35d70
892	12	2024-04-10 11:06:40.636453	5b13b5b3-b125-4497-bf8c-9ee4c962dcd0
893	12	2024-04-10 11:06:42.705911	1345c79d-8e38-4d9d-bd99-c7b37e6a1cc2
894	12	2024-04-10 11:06:44.063999	dc6e0b8c-4e40-44c4-b3bb-90eae5448a76
895	12	2024-04-10 11:06:45.941976	2ff1a4d0-873a-49ab-94c2-9aafbf47feb6
896	12	2024-04-10 11:08:28.03919	d5151032-2dbf-4f2f-a897-8f76580f5e0d
897	12	2024-04-10 11:08:33.072498	9945f9c1-ebda-4a74-a583-d20004d86438
898	12	2024-04-10 11:08:34.748991	77e2c9de-e662-4488-8f2b-38d12c7a0c52
899	12	2024-04-10 11:08:36.97644	7c6afba9-4170-4367-87f9-8196bc783724
900	12	2024-04-10 11:08:38.153138	b81f9ee1-6999-4b0f-8373-2e7ed4106fe5
901	12	2024-04-10 11:08:42.180423	de77c1f1-8e3e-4ea7-8868-810273e369bc
902	12	2024-04-10 11:08:43.359628	424e36d4-ba28-408c-a4cd-066316e467a8
903	12	2024-04-10 11:08:45.887472	78b8d811-266c-4238-ac33-7d22d82e4f76
904	12	2024-04-10 11:08:47.055032	ee63704c-5238-4370-a9b5-9ad26a041b4a
905	12	2024-04-10 11:08:50.672279	97e7eb0e-9d71-4ec8-b4fb-45d9df518f55
906	12	2024-04-10 11:08:51.83272	0cecd713-82a0-4b49-a57b-ff0466df3345
907	12	2024-04-10 11:08:55.431273	8b66863f-4577-4354-96b1-1f1c8df8b24c
908	12	2024-04-10 11:08:56.605779	b961bbab-89b4-4618-889c-894e58f759b7
909	12	2024-04-10 11:09:00.646655	2a9b2fa0-76c1-46b5-9886-61117ea7b2b5
910	12	2024-04-10 11:09:01.853349	2c0826c4-f2f0-4201-9c24-eb7dda1f5387
911	12	2024-04-10 11:09:06.955636	13ab8d4d-a397-4b23-88b3-171f3258b755
912	12	2024-04-10 11:09:08.123861	2ad69315-5dbf-4165-ba7e-c8a5868d0f9a
913	12	2024-04-10 11:09:11.257875	48fa95a8-a413-4996-bfd3-6a0e049e1e6f
914	12	2024-04-10 11:09:13.275155	9ce2d135-6fc3-45f8-b57d-771ee993c4d5
915	12	2024-04-10 11:09:14.47939	2907259a-2bc8-42f5-9c5b-bb9ee684aec5
916	12	2024-04-10 11:09:16.225929	fe3ae2ed-d374-484f-9a66-4dd3f18148ed
917	12	2024-04-10 11:12:26.960922	52bf0e59-0640-4957-bec6-eb13e734ff1e
919	12	2024-04-10 11:12:35.436197	929d272c-8840-4018-870e-361dae266442
918	12	2024-04-10 11:12:33.417051	5385247e-7a82-4920-8f07-3e5abc2f6211
920	12	2024-04-10 11:12:38.486939	06bc7cc7-a1f0-4f7d-b1c4-3cd174008cf5
921	12	2024-04-10 11:12:40.116748	1e233164-328f-4d56-ad7c-b32ce5788a16
922	12	2024-04-10 11:12:45.709198	aca87733-bb24-496a-845f-ba3f48f6c952
923	12	2024-04-10 11:12:47.276253	872caf81-69c8-4601-8d21-20c5410019ff
924	12	2024-04-10 11:12:50.827446	3efa692d-31e0-450a-8e5f-8e9b8a459a93
925	12	2024-04-10 11:12:52.469275	ea94089b-ae1b-486d-ba17-bf7f808762b1
926	12	2024-04-10 11:12:57.552503	ae76e22a-53f7-40ca-9f86-746e7d8d6c08
927	12	2024-04-10 11:12:59.148014	39d5fc1b-0741-4b2c-af3a-3f52ae1b7c57
928	12	2024-04-10 11:13:04.103803	63a6cff0-80a5-404c-aa8a-337f7a324bea
929	12	2024-04-10 11:13:05.680216	71706275-4a59-4c1d-bcc8-3d7edd3d4847
930	12	2024-04-10 11:13:11.016346	ef08b026-d29c-4596-beff-081c37c99996
931	12	2024-04-10 11:13:12.581923	109de9c2-a11e-4640-98d7-7ec22cf5991d
932	12	2024-04-10 11:13:19.476539	c66f47f1-8e5a-47df-a33b-8ae396823d23
933	12	2024-04-10 11:13:21.128985	4f0e806e-0d4d-498b-8dfe-6368a94a747d
934	12	2024-04-10 11:13:25.562581	ea53389b-b0d6-4109-aa8b-2ce24e4d69e2
935	12	2024-04-10 11:13:28.499411	a2bb3a64-1081-456a-963c-0776900b07f7
936	12	2024-04-10 11:13:30.145301	56623148-a56f-490c-ae0e-be9acaf77376
937	12	2024-04-10 11:13:32.591405	17212b60-a7f2-4134-916b-ff89ef0978a8
938	12	2024-04-10 11:19:19.059023	579cecf1-bf51-4921-9ff6-a3548322e36b
939	12	2024-04-10 11:19:27.452362	aa7041ab-02f8-4f91-afcb-181ccc8ecd93
940	12	2024-04-10 11:19:29.670994	0c131beb-0105-4570-94b3-8d4b258fea9e
941	12	2024-04-10 11:19:32.805889	e3da4d45-b521-4a5c-aa88-fb3dcd085f76
942	12	2024-04-10 11:19:34.344627	b5947abf-8883-41b6-9832-bc8730513db4
943	12	2024-04-10 11:19:39.632852	af546111-91bc-46e6-83cc-6a693ef785ac
944	12	2024-04-10 11:19:41.173502	b8b0dd53-5f25-4902-b525-7d861c5634dd
945	12	2024-04-10 11:19:44.412515	76d3003d-6958-45e0-9172-b8f002378bd3
946	12	2024-04-10 11:19:45.841653	28f847e8-8018-4957-b233-efc66eda35da
947	12	2024-04-10 11:19:50.592041	c60f5a39-b54e-4099-a584-ebb8341a268f
948	12	2024-04-10 11:19:52.019836	7e818d44-dc9d-47ce-8fe0-7f2dcf3c82d9
949	12	2024-04-10 11:19:56.468955	37fb28a9-9c65-41cb-a722-e5dfa4bead89
950	12	2024-04-10 11:19:57.847536	6ac2304f-e24a-4af2-ad4b-3cbbaa0f1696
951	12	2024-04-10 11:20:02.718315	113165c0-257f-44e7-81c2-e97db810fbeb
952	12	2024-04-10 11:20:04.198975	c2220554-2422-4ea3-9806-617e263f65c4
953	12	2024-04-10 11:20:10.23928	051cacb4-aca8-40ff-8d6f-17559f520462
954	12	2024-04-10 11:20:11.571456	6ec37225-f980-454c-84ae-da409af6175a
955	12	2024-04-10 11:20:15.327512	7114157b-ab20-48fb-9c06-e79cc0da52fa
956	12	2024-04-10 11:20:17.70086	748490c8-b3f1-48c8-b8f2-804856aae1e9
957	12	2024-04-10 11:20:19.186584	1ec253ad-c66e-47b1-b30d-0a7dfbcd446f
958	12	2024-04-10 11:20:21.267242	d832b4e0-6543-4610-ad8e-490f3aba516d
959	12	2024-04-12 18:36:19.733129	a14b15a1-fb2d-4996-ac4d-b6d780c6b42b
960	12	2024-04-12 18:36:28.696922	82a6948e-75a5-49b0-8483-8ac45e6d0e8e
961	12	2024-04-12 18:36:31.026205	0f21155a-56d6-467b-8461-fe0c875aa3d7
962	12	2024-04-12 18:36:34.084545	7f6076cb-58c3-4a5b-83ec-dc1ba75ed6ca
963	12	2024-04-12 18:36:35.680805	8a83f778-f0e0-4cba-83da-771075085316
964	12	2024-04-12 18:36:40.834879	60103238-96c8-4c21-b9b8-556010cb8d8a
965	12	2024-04-12 18:36:42.308823	c456fb56-5b86-4e04-8b32-df684c57af77
966	12	2024-04-12 18:36:45.401436	988d3139-7c79-4e27-bd9d-9dedf8cf4e2c
967	12	2024-04-12 18:36:46.920336	29af16cd-981f-4283-b10a-6132a901ad3d
968	12	2024-04-12 18:36:51.510158	f4543a34-19c3-453b-8aec-45f803b8fd2e
969	12	2024-04-12 18:36:52.972931	62683a62-6f06-4d09-b973-9bb0627938c3
970	12	2024-04-12 18:36:57.477717	61148abb-35e9-4271-8ca4-917a0e24c43c
971	12	2024-04-12 18:36:58.893954	6245ec55-0004-41e5-aacb-831192032e90
972	12	2024-04-12 18:37:03.669174	f685e814-ad98-4df3-8753-3a618935387c
973	12	2024-04-12 18:37:05.088696	561a7e21-50d5-4c11-9a8f-8cffcb453bbf
974	12	2024-04-12 18:37:11.056614	6d3e41b4-2c3a-4484-9238-c5ac61f1b56f
975	12	2024-04-12 18:37:12.526686	77ac7c91-b69e-494d-9ee4-55c5370b3bf8
976	12	2024-04-12 18:37:16.405007	d6c7db5f-91fa-4bd6-8a89-4143d89652d6
977	12	2024-04-12 18:37:18.718043	d6bef0c2-b476-414c-9096-00ff98d6cff5
978	12	2024-04-12 18:37:20.152357	340e2062-d293-4c21-be75-f6b763cb5d00
979	12	2024-04-12 18:37:22.295641	01ae78b1-a49c-4915-84d4-53bf07a292ec
981	2	\N	e9b95761-ef91-4db8-bcaa-f39a356f0945
980	12	2024-04-22 15:27:11.190722	46852df3-26d8-4dcc-b3a7-ec08da31a697
982	12	2024-04-22 15:27:16.230203	7a05cce6-66b9-4cfa-a7f8-03076bc3ed58
983	12	2024-04-22 15:27:17.994628	cd54c956-de10-42be-b159-c6497ffd6227
984	12	2024-04-22 15:27:20.105851	99e264ee-46f6-4c42-b99f-b5f99afafd59
985	12	2024-04-22 15:27:21.216413	c5aa9d53-5ae5-407f-b99a-c60e564e3c31
986	12	2024-04-22 15:27:24.946468	d371d772-9c15-460b-9936-38e4796f10e6
987	12	2024-04-22 15:27:26.021201	317bef52-dedd-432a-b8c7-3b5a7c91e529
988	12	2024-04-22 15:27:28.431646	fc017e31-6e44-4830-9ec2-502ba4add330
989	12	2024-04-22 15:27:29.50121	849208ec-ea3f-4889-b5c7-fc1a31bc996b
990	12	2024-04-22 15:27:32.911864	32ef6c6e-38ef-43d3-9525-dc6e82b3da0b
991	12	2024-04-22 15:27:34.01236	4735eded-54d9-4b0e-a530-481bd26860ce
992	12	2024-04-22 15:27:37.362588	002490f7-6eb7-45dd-9090-223c7bad6c80
993	12	2024-04-22 15:27:38.431847	f0280efb-c79f-4326-8999-27aaaead7f22
994	12	2024-04-22 15:27:42.067466	cbd57b57-08c0-4d68-af12-6623f513dd32
995	12	2024-04-22 15:27:43.177046	4fa75af8-e899-4d1c-869b-0a9d5d9c855b
996	12	2024-04-22 15:27:47.604669	d4613035-cf4b-4610-8419-f9efb0a2bd8d
997	12	2024-04-22 15:27:48.672638	a3e14912-f54b-45e8-855d-1fe4d8018ec0
998	12	2024-04-22 15:27:51.581817	8d16430b-5581-49a7-ae47-a6fdf1e6ccd2
999	12	2024-04-22 15:27:53.455681	81a211bd-4b63-42ae-9334-d7fad1a261e8
1000	12	2024-04-22 15:27:54.598544	f951b94d-55dd-44a4-b4b7-e7a11d8666ad
1001	12	2024-04-22 15:27:56.229298	fab81df7-07eb-4a57-bee2-9510824f8a49
1002	12	2024-04-23 02:13:38.477752	253c46fe-c584-4760-94a7-2507541e88cb
1003	12	2024-04-23 02:13:46.860305	b54942e2-b843-4f81-a3a7-7964c496a016
1004	12	2024-04-23 02:13:49.110353	63ce6684-3297-42ea-8bab-1e2c66c0bbd1
1005	12	2024-04-23 02:13:52.22274	1ca3e667-b1a0-41ba-a364-6f5d47e36c06
1006	12	2024-04-23 02:13:53.7885	2a4ee5ae-06e5-4469-ac0a-3aae8fe4bca3
1007	12	2024-04-23 02:13:59.010202	66934c61-3a1b-470b-891c-4dc61ba9f119
1008	12	2024-04-23 02:14:00.508503	78e93ae8-b58d-4aea-9ddf-a1a8f15993d9
1009	12	2024-04-23 02:14:03.76979	c8737714-8dd6-4ed1-95e3-5acbcaa301ec
1010	12	2024-04-23 02:14:05.22453	829356a9-b582-4705-a6b0-bd2c6c67468c
1011	12	2024-04-23 02:14:09.785892	75d74d9a-e388-4eb2-8811-b43e17ed3931
1012	12	2024-04-23 02:14:11.232479	da580e1e-243f-43e2-88f9-cf9a9e5c1ea1
1013	12	2024-04-23 02:14:15.644968	0a50085e-4c43-4e6c-be19-baaf231bee86
1014	12	2024-04-23 02:14:17.084561	27d79b9b-53a0-4296-bc58-7b332d90287b
1015	12	2024-04-23 02:14:21.860662	af034fe0-4a75-4119-aa7d-0aeaa7dab081
1016	12	2024-04-23 02:14:23.308194	4d19051a-61fa-4567-a7c2-5a32ef06ec10
1017	12	2024-04-23 02:14:29.208473	54238352-9c24-43b0-8212-bfbbca08f85f
1018	12	2024-04-23 02:14:30.591873	b818838a-8f85-4c6c-a284-0deac69fd302
1019	12	2024-04-23 02:14:34.442547	308548d5-896e-4b08-a779-046b1434df9f
1020	12	2024-04-23 02:14:37.017426	85ce0155-120e-44ca-b300-d0cd4900b2a9
1021	12	2024-04-23 02:14:38.433449	d05c1d96-3c70-4789-99fb-074b7024d1d7
1022	12	2024-04-23 02:14:40.595878	3903329b-deb9-4d9f-bf7e-6d361cb060c3
1023	12	2024-04-23 18:15:58.216648	3f3820e2-11bd-4690-82a8-391649168dd7
1024	12	2024-04-23 18:16:08.156849	c7da5fdf-f9f9-4216-a47d-5e91c5a5788b
1025	12	2024-04-23 18:16:10.762158	89981896-156c-4dcf-a654-fe50982e4679
1026	12	2024-04-23 18:16:14.211985	584a39db-0db3-43ed-bb8c-d4e98aecbb60
1027	12	2024-04-23 18:16:15.980535	42c4ea2b-ebfd-4755-a03e-ea2c25744310
1028	12	2024-04-23 18:16:22.126075	4abfbd47-d5db-44a3-a092-cdae75ffe0af
1029	12	2024-04-23 18:16:23.831537	37910875-ea36-42db-b7a2-8f17f04c0a8f
1030	12	2024-04-23 18:16:27.707352	249a205c-383a-4a20-96ae-4b0a1e8797ca
1031	12	2024-04-23 18:16:29.378586	a01fa855-c8a1-436c-90e1-160d06c6284c
1032	12	2024-04-23 18:16:34.65767	4a175173-3b17-439d-b459-a2a9c70e05ad
1033	12	2024-04-23 18:16:36.310489	5d119657-8695-48eb-b81d-1022fc22b13b
1034	12	2024-04-23 18:16:41.467923	9e94aa95-6140-4333-be59-bc92d99f4746
1035	12	2024-04-23 18:16:43.17533	70d4b4bf-53a0-47af-a313-5cbb2ff96aae
1036	12	2024-04-23 18:16:48.769937	85ca6b19-4ed5-4bc4-b824-e01e69142de9
1037	12	2024-04-23 18:16:50.395865	29a9cedc-9185-4106-a750-03e689d0d7f6
1038	12	2024-04-23 18:16:57.71667	7fb4def6-d735-43c5-882b-fe054f6e6bda
1039	12	2024-04-23 18:16:59.353564	19470196-8de3-4000-8b94-6a13be681fd8
1040	12	2024-04-23 18:17:04.085737	eeccc724-05e8-4bee-8257-4446782d15be
1041	12	2024-04-23 18:17:06.934585	e6e5a4b9-9928-4fca-8777-c0666140e958
1042	12	2024-04-23 18:17:08.639355	9c982605-5cd4-4650-add3-e4349d053412
1043	12	2024-04-23 18:17:11.263738	144b897b-2a80-46bd-8c62-e2499c2ab653
1044	12	2024-04-23 19:00:16.597732	cce82560-53b4-486e-bfd7-599e04dc00c1
1045	12	2024-04-23 19:00:25.366893	fd978ff3-1e6a-4b30-99ba-c8556896212b
1046	12	2024-04-23 19:00:27.666288	841a83f3-d90c-4f7b-81da-44e8a19c8c02
1047	12	2024-04-23 19:00:30.969002	125a908c-2ef3-46c3-99f1-95602a26039f
1048	12	2024-04-23 19:00:32.524575	d6fb7595-900c-4eec-ba60-acb07bc3d869
1049	12	2024-04-23 19:00:37.753584	dd102ca1-f153-4f3d-ad8b-807a8a20966a
1050	12	2024-04-23 19:00:39.176519	575ac853-776c-4c64-b713-2d091db3c443
1051	12	2024-04-23 19:00:42.326482	72271b02-5f7e-4dba-bba5-28a80f47264b
1052	12	2024-04-23 19:00:43.908357	84da99b4-6665-4377-bcbf-db78437b3f1c
1053	12	2024-04-23 19:00:48.189612	800225f8-807f-4c26-825d-711210be07f8
1054	12	2024-04-23 19:00:49.553702	10f1d56e-2783-419b-9f76-40894d7d64cd
1055	12	2024-04-23 19:00:53.770857	7d6180a4-e729-49b2-bcf3-650f716a9c73
1056	12	2024-04-23 19:00:55.11395	de8e56f7-d57f-4430-a0ba-282a9a6a441e
1057	12	2024-04-23 19:01:00.224423	a19a32cc-a6b8-4663-aaa1-264c08648f75
1058	12	2024-04-23 19:01:01.625402	38d0126a-8565-4995-a021-e98d03e45d01
1059	12	2024-04-23 19:01:07.712993	8d15cc9a-194c-4917-b96b-355548109e90
1060	12	2024-04-23 19:01:09.116811	30176596-82d2-4033-9e60-ba30c73a81df
1061	12	2024-04-23 19:01:12.856232	b106bfd0-aa1e-4fff-819c-20bf9dc1d058
1062	12	2024-04-23 19:01:15.202977	cdea78cd-034d-485f-a1dc-e581a039de6d
1063	12	2024-04-23 19:01:16.59991	f08eb7e1-fcc5-4789-92fe-20827fcd1f5c
1064	12	2024-04-23 19:01:18.759432	d013cfe9-1194-4450-a16f-45c16d8e6414
1065	12	2024-06-16 07:21:01.652678	ae5b9806-ade9-42f1-b1cc-26626d19baa1
1066	12	2024-06-16 07:21:05.817168	3d13de26-5ab4-4ddc-8624-55fd38ac3a9b
1067	12	2024-06-16 07:21:08.372484	5c99f64b-2377-4459-b0ff-e2d78d8c45ab
1068	12	2024-06-16 07:21:14.308744	0f22b313-7dde-42db-9b56-142c7d1f40c9
1069	12	2024-06-16 07:21:16.187414	ace19d20-7284-42da-90b6-961d6bd887f3
1070	12	2024-06-16 07:21:19.672424	132b5bb7-f64b-4994-b364-29b18e1d8fdf
1071	12	2024-06-16 07:21:21.438499	7cb70061-55b2-4c45-a5a5-a2805e326cc2
1072	12	2024-06-16 07:21:27.429727	48232e04-f45b-459a-b66a-6e1fd0e99b72
1073	12	2024-06-16 07:21:29.228433	4b9ef47b-4086-4773-90c2-453413dab19a
1074	12	2024-06-16 07:21:33.141303	d425f9a0-f7d8-4749-a69d-c60d9b6c5bf9
1075	12	2024-06-16 07:21:34.824414	9ae8b8d1-f0fe-4b81-8ee4-a573b3b4a1d7
1076	12	2024-06-16 07:21:40.037181	91d36b96-8412-435e-bcb3-2ba6b7b1a102
1077	12	2024-06-16 07:21:41.774158	8240d2dc-32e8-4202-bf0f-3ae11fa1fa7c
1078	12	2024-06-16 07:21:47.132372	f15d8d3d-6fa0-4c6b-a75d-801e064955e3
1079	12	2024-06-16 07:21:48.854669	be9a10d0-80a6-49f4-a646-b03e2d197941
1080	12	2024-06-16 07:21:54.536418	d7f3d06c-1d1a-486b-8311-0dcf31e3e6e7
1081	12	2024-06-16 07:21:56.224484	1305bd20-3160-4017-bf7d-2b7833ace9d0
1082	12	2024-06-16 07:22:03.482037	825fd66d-eb5c-40c4-9006-c87724597da3
1083	12	2024-06-16 07:22:05.125383	6d06461a-a8c2-4961-bdef-ee94c8581a2a
1084	12	2024-06-16 07:22:09.81109	326a086a-c4fa-41cf-8e4e-0e5cb10f30a2
1085	12	2024-06-16 07:22:12.812391	c204a5a2-7cb2-4b27-aba2-f9aa59108011
1086	12	2024-07-05 16:16:34.686486	522a3b43-0b42-4a00-a9af-fa491e4a17d9
1087	12	2024-07-05 16:16:39.696411	558f7c7f-f68c-4982-b959-6fd2834b379d
1088	12	2024-07-05 16:16:42.296973	42de0e4c-8ab2-45f9-b745-a9f1b34c6017
1089	12	2024-07-05 16:16:48.207495	d3c5854b-7080-4e79-ad86-aa666c620234
1090	12	2024-07-05 16:16:49.689776	b7557d65-6339-445d-8c3d-ad939f96690d
1091	12	2024-07-05 16:16:52.588621	c9dd548e-0584-437b-9754-5ca509a94f9e
1092	12	2024-07-05 16:16:54.027555	4b3e2593-e6e7-428f-8981-41d74637eae3
1093	12	2024-07-05 16:16:58.700678	89a59174-1c05-473b-9c0a-a87ccee993e2
1094	12	2024-07-05 16:17:00.084369	04be81bd-a9f7-4a8e-91be-fcc3fe2f189d
1095	12	2024-07-05 16:17:03.524468	23820f2c-f0c4-4922-af76-8e28add5b96c
1096	12	2024-07-05 16:17:04.789406	70ccd759-d567-404a-871f-517b01c38063
1097	12	2024-07-05 16:17:08.817837	3db2b81d-a96e-456f-9e81-a634e801d897
1098	12	2024-07-05 16:17:10.053017	cd7e2ef5-07ba-4c99-aaca-1d6c86d6909f
1099	12	2024-07-05 16:17:14.140617	295e437e-54df-4b17-b88a-685d008cff72
1100	12	2024-07-05 16:17:15.533611	87d2bed9-260d-4163-8f46-8fa6cf21c56f
1101	12	2024-07-05 16:17:19.690255	a5ee5470-1865-4858-882b-4cef3dbc19f0
1102	12	2024-07-05 16:17:20.89061	e0b1af06-6d6d-416c-8161-427c1371ed2f
1103	12	2024-07-05 16:17:25.984793	d6f65882-40c3-4ca4-924f-7e0870c0fd62
1104	12	2024-07-05 16:17:27.213134	c9a1f18a-ca1b-4751-951e-d4c8f1df1253
1105	12	2024-07-05 16:17:30.479145	b5476a7a-acf5-4127-a095-de923dd51561
1106	12	2024-07-05 16:17:32.416405	73b621bd-19f3-40df-88dd-7dc1e41a3ef4
1107	12	2024-07-18 19:28:24.089986	d567c33c-1629-4689-a0ca-eb242047349f
1108	12	2024-07-18 19:28:35.002852	def0bb05-e55f-44a7-adbc-c38926d659ed
1109	12	2024-07-18 19:28:37.691765	f60ce215-8152-4995-8559-e33ecfa6a88d
1110	12	2024-07-18 19:28:41.637466	e171abb5-f0d3-4624-b0a7-cdb7b7a55a74
1111	12	2024-07-18 19:28:43.603214	fc62e1e9-b838-4427-83a8-2610c81788dc
1112	12	2024-07-18 19:28:50.300506	c3e6f6c3-edcf-46d9-b27c-51bdc679eb35
1113	12	2024-07-18 19:28:52.190491	7e7455e4-5c9c-431e-b055-318d338df555
1114	12	2024-07-18 19:28:56.166464	8aff7709-a7e0-4347-85dd-981ff296bddb
1115	12	2024-07-18 19:28:57.908734	2465c7b1-f518-4cc5-bd06-f560ca0a3434
1116	12	2024-07-18 19:29:03.524657	bb6afedb-be7b-4d05-902a-2e239c95501b
1117	12	2024-07-18 19:29:05.256647	9c252ae3-fff4-4866-99df-51427fc1dcb6
1118	12	2024-07-18 19:29:10.756617	0df0720b-3c1d-4298-93f2-d4c3ce24b33c
1119	12	2024-07-18 19:29:12.768512	5c20b11f-5c43-4b02-8311-867b1d462e55
1120	12	2024-07-18 19:29:18.765639	a4d830d2-47ff-4cd3-a11e-371f4c6fbd9d
1121	12	2024-07-18 19:29:20.522454	48ebcd62-98c6-4d6f-b4ca-f531f7b58f9c
1122	12	2024-07-18 19:29:28.075264	7350bad3-6a65-40ba-b295-23ea30a24908
1123	12	2024-07-18 19:29:29.919913	138ae43c-862e-4c25-ab38-79cc4a25b8a6
1124	12	2024-07-18 19:29:34.88378	0805d52d-aa3f-45ba-973b-7db2907bd501
1125	12	2024-07-18 19:29:37.717463	1fb45377-efe8-4864-940a-3315951a1962
1126	12	2024-07-18 19:29:39.549611	48c57733-e47a-43a1-b48d-ab87b67ab4c5
1127	12	2024-07-18 19:29:42.304476	fb3e2d61-9416-4dbe-92c5-d7e6c04dfef9
1128	12	2024-07-19 07:24:40.037573	1829cb27-f53b-4719-b415-2ca19744a0a0
1129	12	2024-07-19 07:24:50.603942	8e30e5cd-a36f-4b03-977d-fa92f364e945
1130	12	2024-07-19 07:24:53.141555	77a7d540-0e81-453e-8cc6-0db4f2befc65
1131	12	2024-07-19 07:24:56.936714	853f39f3-6de0-4d1b-bb81-59ca9dc1f9bf
1132	12	2024-07-19 07:24:58.672536	219f55e8-9ec9-4d69-a1ca-4059352a884e
1133	12	2024-07-19 07:25:04.985045	ed933e7a-de85-42e4-ae1a-05d0a55a5c12
1134	12	2024-07-19 07:25:06.926381	f349bad4-8550-4d0d-a1e0-c34dee18eaf3
1135	12	2024-07-19 07:25:10.552668	4dc25e32-8389-4335-bb31-f5e833dcb6f1
1136	12	2024-07-19 07:25:12.132187	15bdf059-4061-4347-8c46-008f7af1b001
1137	12	2024-07-19 07:25:17.090771	0bf7e39c-bcbc-46f9-927f-31dbeed8572b
1138	12	2024-07-19 07:25:18.571528	0a3039c7-fbec-4e73-aad6-580b4af4254f
1139	12	2024-07-19 07:25:23.338089	bd4c486d-fc39-4f8b-8e36-d7e8a17a25d6
1140	12	2024-07-19 07:25:24.9099	6db3988f-5ff9-4aeb-b34d-8a6690717f62
1141	12	2024-07-19 07:25:30.068951	e8e56f7c-4b58-47cc-9605-69fe570777b6
1143	12	2024-07-19 07:25:38.140685	aa70a7b6-d73c-47c3-b8ef-a86159011740
1142	12	2024-07-19 07:25:31.543892	7c8f4690-c9c0-4c20-885f-65da2644711d
1144	12	2024-07-19 07:25:39.67879	e99d4e81-0e80-416e-9efb-d7802fa42003
1145	12	2024-07-19 07:25:43.719206	823e6f49-539d-4a98-bf85-495648f51175
1146	12	2024-07-19 07:25:46.103222	b0863197-0715-44f6-ab43-98641f4e871c
1147	12	2024-07-19 07:25:47.531926	93e6cc7a-b728-49e4-8f33-6414bf59ae88
1148	12	2024-07-19 07:25:49.857986	74d5d8a4-0ea5-44ba-98a4-7604aced1a3f
1149	12	2024-08-01 14:29:26.282399	5ec25c96-967a-44d8-a90b-49c265af06cf
1150	12	2024-08-01 14:29:32.620537	251ac847-ff4b-452b-bf92-2bb785f4c255
1151	12	2024-08-01 14:29:34.465178	fbcf601b-4c16-460b-aaa0-85c2c579a902
1152	12	2024-08-01 14:29:36.996863	6e0fab59-a341-4219-96ab-1e2836f88e15
1153	12	2024-08-01 14:29:38.296341	22262e57-b27a-43af-9ba0-ce04b3704499
1154	12	2024-08-01 14:29:42.775684	ea912a26-f1f9-453b-90e0-60a20ffca6f2
1155	12	2024-08-01 14:29:44.093446	a8044868-8bc2-4b70-b80e-46df0e5a6e1d
1156	12	2024-08-01 14:29:46.891436	80e38976-df57-4217-8b69-1b9bca846919
1157	12	2024-08-01 14:29:48.235522	bdadaf38-5eb5-4107-90b9-f7270dde5598
1158	12	2024-08-01 14:29:52.192643	ddf2c9a7-8c05-4b06-83d3-2a731b4da2f5
1159	12	2024-08-01 14:29:53.457886	10a92af0-8019-4720-869a-be484cbcd3ff
1160	12	2024-08-01 14:29:57.428303	e04a3a88-7b7a-4d77-bba0-6609b12e00c1
1161	12	2024-08-01 14:29:58.743084	d510f057-0f1b-4e92-a5ff-9b397695a8bf
1162	12	2024-08-01 14:30:03.454824	2333648d-e8c4-4c66-bbb4-bc1be46eb11e
1163	12	2024-08-01 14:30:04.8483	6950f65b-b103-40c1-9ecd-debddb68b5ed
1164	12	2024-08-01 14:30:10.42368	fc36edcc-dbfd-4ceb-b921-4c81d4a3e03f
1165	12	2024-08-01 14:30:11.717136	7dfed98d-3557-469e-94f1-76b50d2eacf7
1166	12	2024-08-01 14:30:15.21043	42d94c3e-ebe5-465c-8152-7e5595e4f1f1
1167	12	2024-08-01 14:30:17.394005	6205b674-341a-4e0b-afdc-9168b957c8f1
1168	12	2024-08-01 14:30:18.67653	e5dee3a4-3f04-4b8d-be91-59dd40c5e802
1169	12	2024-08-01 14:30:20.600016	6c9f037d-accc-4a01-94f0-6b02f548bab5
1170	12	2024-08-01 14:34:40.48733	11534a44-9776-41c7-a1c6-445fc004cca5
1171	12	2024-08-01 14:34:44.189206	ef225dc3-b4b9-4ed0-8f17-37a201a86afe
1172	12	2024-08-01 14:34:46.441133	109c9e9e-f5c7-4c15-8f47-7e3783e2e92f
1173	12	2024-08-01 14:34:51.809735	ddf3fa18-aff7-4d7c-b5cc-89d4f0b5fd8b
1174	12	2024-08-01 14:34:53.453566	3958691a-3ce3-4d12-a1c8-bdb01e9a1bed
1175	12	2024-08-01 14:34:56.565548	b06dded8-04ed-4c48-91ca-9820072a458c
1176	12	2024-08-01 14:34:58.196471	9c152896-9a29-4934-9ad8-aa7871899160
1177	12	2024-08-01 14:35:04.224046	828a8583-6d83-4960-ae53-c291b4fd13b8
1178	12	2024-08-01 14:35:05.91257	7adf701f-2ff0-4b89-9aac-0abe68ca9e7d
1179	12	2024-08-01 14:35:09.679838	f48ada7d-c608-4756-82c3-0278f647ec0b
1180	12	2024-08-01 14:35:11.343727	4f66af74-fc28-43b7-9bca-ca59dd026909
1181	12	2024-08-01 14:35:16.448724	6652ae82-87d9-4fe3-9f7b-4261d6b9fb14
1182	12	2024-08-01 14:35:18.093206	9e4f0a6a-b2ac-497d-8682-b233d3098753
1183	12	2024-08-01 14:35:23.248531	8e7dd6dc-16ac-4c7f-80c3-f8e99c560766
1184	12	2024-08-01 14:35:24.857658	6f42b9ff-d1e0-467a-9683-6ed5c9fd84a6
1185	12	2024-08-01 14:35:30.404895	5684acf1-97c6-4232-8977-cf2a3bd91c72
1186	12	2024-08-01 14:35:32.006067	547c0f55-57db-45d6-8bf4-5a14fd7deb7a
1187	12	2024-08-01 14:35:39.026634	a7c5d46e-8b0a-424a-9fa0-c45efb11e5bb
1188	12	2024-08-01 14:35:40.684384	e1a64442-d88a-481f-a7a1-82c4a90d6b30
1189	12	2024-08-01 14:35:45.575259	b8587fd6-6d12-49ad-b014-25c1d2e9fb83
1190	12	2024-08-01 14:35:48.397268	4d1d8404-14c5-4b75-b065-3fb21a55b395
1191	12	2024-08-01 14:39:52.115957	cf9915ab-4a40-483c-973c-06da740dcb6e
1192	12	2024-08-01 14:39:57.607468	e2c282a0-bfdf-4a46-a146-2ffd1e7e4169
1193	12	2024-08-01 14:39:59.393384	2a9e8946-3d79-4ef2-8bbb-5e8223830c2a
1194	12	2024-08-01 14:40:01.972646	f4731922-b302-4d7d-b9ba-fcce4c325db2
1195	12	2024-08-01 14:40:03.376962	c086042e-1d63-4bf0-9c0b-ddb98ecb138a
1196	12	2024-08-01 14:40:07.793492	a11aae09-bde8-4c6e-8914-9ebf5f419e1b
1197	12	2024-08-01 14:40:09.069957	15f8043e-6da9-4225-9eef-59f00e214e69
1198	12	2024-08-01 14:40:11.788603	fbc086c8-4f78-4569-8350-30b5f63e2dfa
1199	12	2024-08-01 14:40:13.049447	adf1fd53-20b2-4f0d-a09c-0651754c0837
1200	12	2024-08-01 14:40:16.936203	af3316e2-568e-4682-8fe7-6423c0f5d692
1201	12	2024-08-01 14:40:18.143635	7756a2e9-8e6b-474c-8060-cfaed89ac3ec
1202	12	2024-08-01 14:40:21.926997	591e9e09-99b9-49d4-90b2-edd88e0e9731
1203	12	2024-08-01 14:40:23.198495	97b13e33-9c2f-469d-8134-a25c12cfe549
1204	12	2024-08-01 14:40:27.287983	a6a8d2ed-5e72-4f4c-9d70-c47c1cf3317e
1205	12	2024-08-01 14:40:28.516796	702d6185-1026-444f-889e-2deede3b1a3c
1206	12	2024-08-01 14:40:33.771112	70dc17fa-9a91-465f-95aa-4830241baab1
1207	12	2024-08-01 14:40:34.971792	4a823bd6-8dbf-4452-9123-de6555d0f273
1208	12	2024-08-01 14:40:38.302222	720d0d3b-6527-47b4-bfe3-e7ba1a6e8e7a
1209	12	2024-08-01 14:40:40.392716	08a30ce6-09ae-44d6-ac06-7760d13ef8be
1210	12	2024-08-01 14:40:41.761522	a456e7d8-4ee1-4bdf-96db-7d0d4b6e3243
1211	12	2024-08-01 14:40:43.682005	2f150a12-7fa5-44c8-bd1e-6be132189db8
1212	12	2024-08-01 15:14:47.865181	dbc8f99a-4be9-410f-82a1-0fdbff997a02
1213	12	2024-08-01 15:14:53.683	ed2fc176-814d-4dc4-8065-5f62c72b2d69
1214	12	2024-08-01 15:14:55.53603	e6cc7cb9-43b6-44d6-8fa2-e64bbf285c0d
1215	12	2024-08-01 15:14:58.116042	0d33a4da-2d70-4583-9f0c-b4ab46d0e64b
1216	12	2024-08-01 15:14:59.48744	3694fba8-b879-4ce2-9bb7-d11eef05b981
1217	12	2024-08-01 15:15:04.401865	611b4b43-2610-4e80-8729-c8928b0388eb
1218	12	2024-08-01 15:15:05.832508	f3ae7ace-7ece-4e25-88ec-f7ce4d49564e
1219	12	2024-08-01 15:15:09.061842	1b86c51c-94df-4f34-8e71-27f178326832
1220	12	2024-08-01 15:15:10.396555	a699d21e-365d-4afb-ad07-b816dc4e4423
1221	12	2024-08-01 15:15:14.641153	962fd53a-5737-4872-9d03-ea0144ab90bb
1222	12	2024-08-01 15:15:16.045354	e94ae42b-d96c-486e-9812-e672ffbc496f
1223	12	2024-08-01 15:15:20.281428	8519d60b-61b5-490a-a9e8-13c67d6e0c12
1224	12	2024-08-01 15:15:21.599046	7803b585-1a1e-45a6-8326-d4af28180321
1225	12	2024-08-01 15:15:26.117201	fe182229-3e94-4e69-a871-53d4c11dddce
1226	12	2024-08-01 15:15:27.424422	df9a307a-e320-4da7-ae71-a51d48c7c5ef
1227	12	2024-08-01 15:15:33.13443	dd081e6e-8080-46ab-8b6e-161fe16c410e
1228	12	2024-08-01 15:15:34.453905	5b912663-564b-4ada-8ff0-f6279551ceb4
1229	12	2024-08-01 15:15:38.1863	b0deefbf-65a0-47d3-824f-6421d265c5e7
1230	12	2024-08-01 15:15:40.499543	c4e656b1-c4c2-444d-b9e2-1eaebab3cf4d
1231	12	2024-08-01 15:15:41.887017	666d35db-9295-4602-809a-d234a760cb7a
1232	12	2024-08-01 15:15:43.937435	b035ecba-d6e3-4298-b619-e270eef58939
1233	12	2024-08-19 10:21:25.46153	da092fd5-cef9-4d1e-9c71-e93abb050a2b
1234	12	2024-08-19 10:21:30.583924	3bf1ded6-d973-4bfd-8b49-57f4a3e92a1a
1235	12	2024-08-19 10:21:50.700743	b7cbf262-f69f-4eee-b5c9-ba58e5aa581b
1236	12	2024-08-19 10:22:00.69907	ea588814-48da-43f8-a8b9-6e6b952b0661
1237	12	2024-08-19 10:24:53.054175	d2413e5f-4d2f-4170-9aaf-0f4a66de051d
1238	12	2024-08-19 10:25:02.434486	5dd4cb49-2a81-44c0-9243-7c4795b4a64d
1239	12	2024-08-19 10:25:05.323521	ea8ba42b-732c-4ea5-96d4-ecedf69c1a34
1240	12	2024-08-19 10:25:09.753677	ba65fb28-f7fe-4672-aa23-b30e500d6201
1241	12	2024-08-19 10:25:11.958567	b28d5276-d7cc-4add-beb9-f4ef1960b3fb
1242	12	2024-08-19 10:25:19.659178	3a9d3674-63f7-4648-8d00-3badcddb534a
1243	12	2024-08-19 10:25:21.820363	9ad01f72-72b4-41ed-b538-91fd8f14cab1
1244	12	2024-08-19 10:25:26.677463	100ad07d-0892-40bf-ae99-b9b546a1dc06
1245	12	2024-08-19 10:25:28.807052	e7e3ec59-f816-4248-aef7-b139a661ffd5
1246	12	2024-08-19 10:25:35.78263	bcc02181-8f24-41e1-bd3e-fb15a57dbc6a
1247	12	2024-08-19 10:25:37.92669	7e20d985-eebe-43c5-b3eb-b2b984218851
1248	12	2024-08-19 10:25:44.910078	2d8ffa3c-4c3e-459f-bfb4-59aa98db879e
1249	12	2024-08-19 10:25:47.055444	0027e719-04e0-4bd2-8ca4-db47c817a81c
1250	12	2024-08-19 10:25:54.571708	cdfa4e99-36d8-4d78-9aec-3b79de7804a6
1251	12	2024-08-19 10:25:56.779309	f9700f3e-2374-46b0-9a72-2d3dfb596921
1252	12	2024-08-19 10:26:06.500627	6a5e0f4d-d3c9-4a3a-8886-c322e706f85f
1253	12	2024-08-19 10:26:08.804336	202a054c-f366-4284-8cf0-fecadd0cb915
1255	12	2024-08-19 10:26:19.17592	b637cbf4-92f8-4faa-b051-80def1732d04
1254	12	2024-08-19 10:26:15.126106	835ed668-d1d4-433a-8461-7c38d9ab05e4
1256	12	2024-08-19 10:26:36.293137	d7eed8a0-d16d-4e78-a381-cc1e622b3260
1257	12	2024-08-19 10:26:41.355557	3f266a7e-6d50-4427-af8b-b4574be8411d
1258	12	2024-08-19 10:28:19.343612	91e5f54a-3a55-430c-9bc0-50c5bada1ba2
1259	12	2024-08-19 10:28:22.440337	dc4148cd-ff2c-47c6-b704-1c8b6d5137db
1260	12	2024-08-19 10:28:24.301259	c1446138-e817-477c-8e85-bbb72da265db
1261	12	2024-08-19 10:28:28.248462	c3c9a37f-98b2-448c-abcf-c030bff9e337
1262	12	2024-08-19 10:28:29.463538	9b8303e9-da81-4c67-bf33-92b625ac9959
1263	12	2024-08-19 10:28:31.779178	15aa1313-3b04-460e-a53e-8f8574119c2f
1264	12	2024-08-19 10:28:32.986214	03dc43fc-0ae1-4e71-8fd0-98e90a76b818
1265	12	2024-08-19 10:28:37.177748	c84982c9-b5c2-48ce-a34e-d7d6275edb42
1266	12	2024-08-19 10:28:38.397834	0c236451-eaaa-43f5-9fe9-fe0a9f1a1699
1267	12	2024-08-19 10:28:41.067538	fc1a4eb4-c760-4620-9376-bfc2f125c51c
1268	12	2024-08-19 10:28:42.272668	eeb3878f-a3b5-4166-a240-07e6a599c67e
1269	12	2024-08-19 10:28:46.020518	c7feace2-e8f9-44b0-96b5-0bfa7d768eb2
1270	12	2024-08-19 10:28:47.246734	280d41cc-2496-46d1-99ca-6f5bd7b83076
1271	12	2024-08-19 10:28:51.031948	9cc23e76-15c2-46ff-bc4c-e943e8007dd0
1272	12	2024-08-19 10:28:52.253982	719f9933-b10e-406b-930e-fce726e758c3
1273	12	2024-08-19 10:28:56.325642	1fec8378-8dc6-4242-81df-ae5006dd105c
1274	12	2024-08-19 10:28:57.515356	1cdd76cd-1e8d-4cd8-9268-67b168aa44d4
1275	12	2024-08-19 10:29:02.780933	81311088-3ed4-4874-89c8-0d30e3a156a6
1276	12	2024-08-19 10:29:03.979131	6dbe899e-5b3a-4a9c-9e3b-16187e343250
1277	12	2024-08-19 10:29:07.281371	5aa74410-c8ae-4d88-ac19-76e299363c06
1278	12	2024-08-19 10:29:09.373196	4d3f5576-0d44-4034-bd7d-5fe0da9913c7
1279	12	2024-08-20 09:54:43.515283	bf83e004-512d-4103-8477-614bca9c3f60
1280	12	2024-08-20 09:54:47.18853	e792db1e-07d1-4e17-a6a5-e5f117197ba4
1281	12	2024-08-20 09:54:49.477727	c80c5b79-044b-4bfe-a52e-bc1878e7e788
1282	12	2024-08-20 09:54:54.702818	e366207b-5387-443c-bf9d-7ce950f991c2
1283	12	2024-08-20 09:54:56.318366	83db54a1-da49-4946-a93b-8bb3ff3b75a5
1284	12	2024-08-20 09:54:59.384792	370c48af-4eb4-48ad-9fde-9a359b9b52ec
1285	12	2024-08-20 09:55:01.007564	f92217c8-1d7f-417f-b0a8-3438e550d930
1286	12	2024-08-20 09:55:06.717462	8e869341-68ec-416c-9346-36f374e1f433
1287	12	2024-08-20 09:55:08.351447	d801440c-3525-4312-84b0-906932c69f3e
1288	12	2024-08-20 09:55:12.017756	64946354-989c-4795-b3f6-7b385aa85abc
1289	12	2024-08-20 09:55:13.627771	b8c8e5ca-9a67-4b06-8b9e-63fd01c5a63f
1290	12	2024-08-20 09:55:18.775489	90fc8808-2d27-4bf3-80ef-3aedbfdb912a
1291	12	2024-08-20 09:55:20.343517	d2619d81-5796-42ed-9e30-19c3ce304b22
1292	12	2024-08-20 09:55:25.474065	33300330-66fc-4b9d-b40b-f87c14c867b4
1293	12	2024-08-20 09:55:27.094721	e3ab134f-82f8-4303-8bfa-25fcfa564a04
1294	12	2024-08-20 09:55:32.464915	839c9686-c481-4575-ba5e-fac83f6c100b
1295	12	2024-08-20 09:55:34.058155	17031103-99bd-428e-b5c5-740358ac25ac
1296	12	2024-08-20 09:55:40.996374	5ddcd38f-6331-44a6-a21a-66aa57387985
1297	12	2024-08-20 09:55:42.586752	9264895b-dc64-4757-abbb-dfdb2ae628e5
1298	12	2024-08-20 09:55:47.150036	a840825f-e49d-4372-9a64-dc7052a51a5c
1299	12	2024-08-20 09:55:49.982904	b0e4a4f9-351e-491c-90be-7065dca9bda4
1300	12	2024-08-20 15:08:58.164497	99b8af9a-59dd-47dc-ab06-b54040293fb0
1301	12	2024-08-20 15:09:01.492362	84b23ddc-8a15-4783-97d6-a2fd93521f0c
1302	12	2024-08-20 15:09:03.330408	768439be-9efb-4c5b-81ef-6f5b6ba69eb7
1303	12	2024-08-20 15:09:06.848801	09675d00-2637-48cc-a802-da2cc0a77202
1304	12	2024-08-20 15:09:07.912914	32920263-5184-46d6-81be-241fa7a36523
1305	12	2024-08-20 15:09:09.953348	7156bda3-dbaf-49ce-a572-b4d408ed28f1
1306	12	2024-08-20 15:09:11.017676	9fa9a75d-9e25-422b-8e4d-e80ccee7ba68
1307	12	2024-08-20 15:09:14.613705	db2597ea-317d-4dc9-93b4-20dd86e238f1
1308	12	2024-08-20 15:09:15.644265	34c92074-116a-4b25-9493-bcd438857508
1309	12	2024-08-20 15:09:17.968476	5a98e463-a9d6-4e6b-bdcb-cae12319ac2d
1310	12	2024-08-20 15:09:18.979841	4dbd62e1-2eec-428e-91f9-4255e7360d21
1311	12	2024-08-20 15:09:22.191093	64735140-b5f3-4055-af55-12b0d4d16667
1312	12	2024-08-20 15:09:23.207038	d262c452-c431-4b33-b013-60ae641b07d1
1313	12	2024-08-20 15:09:26.45706	f39650e7-a1d5-4b7b-a385-59ac703aedbc
1314	12	2024-08-20 15:09:27.525272	98cf2e85-f6c1-474a-aff5-90d4c3f0e245
1315	12	2024-08-20 15:09:31.190687	c0ae327d-fa49-4420-b725-9e951cd9f47d
1316	12	2024-08-20 15:09:32.253239	d829c7c5-e675-4dbc-bb9c-1c77d4ef68e8
1317	12	2024-08-20 15:09:36.628667	b3fba4cd-6529-47c8-9593-619e05329d57
1318	12	2024-08-20 15:09:37.656295	ec9c99e1-8d80-4e4e-b3bf-558ae616db8d
1319	12	2024-08-20 15:09:40.550952	4225c0ea-3739-4a96-badf-6641394fc227
1320	12	2024-08-20 15:09:42.358363	bb3886b4-a0d8-4b83-bf52-dec0b49a9730
1321	12	2024-08-28 13:54:22.020409	023b6660-e8e5-415f-9e49-148caee49240
1322	12	2024-08-28 13:54:25.130462	7d0cbde7-9831-4e79-ac41-a891b9b29d74
1323	12	2024-08-28 13:54:27.077901	430a7b07-80e1-446a-ac00-c6d45c7e71d1
1324	12	2024-08-28 13:54:31.349562	8fc8e821-5ed8-4c90-a337-0c8ed650bd49
1325	12	2024-08-28 13:54:32.635702	3a79e44c-b092-4966-86e6-4ecb961f4f85
1326	12	2024-08-28 13:54:35.106836	6638edec-db78-4cdb-96a8-08a17b114c68
1327	12	2024-08-28 13:54:36.442945	384a32db-cc4d-47a7-aa4a-da872f3f811e
1328	12	2024-08-28 13:54:40.730206	b087e237-0e8e-43b5-81b8-d5933be537b1
1329	12	2024-08-28 13:54:41.959175	77d3c9ba-01ac-4026-8170-c61611e2d3aa
1330	12	2024-08-28 13:54:44.751847	a1750cbd-6ec7-4d1f-ac08-e8f51fbcae9b
1331	12	2024-08-28 13:54:45.982296	f5104717-5032-46d4-b528-485a818e6ea3
1332	12	2024-08-28 13:54:49.822721	d75495cd-1ee4-437a-ad25-969593dc98d2
1333	12	2024-08-28 13:54:51.081345	76f89861-9a61-4c57-8e53-0271f4f1d35c
1334	12	2024-08-28 13:54:54.962441	ade3162b-1961-4bc7-a13c-50f9e34eb3ee
1335	12	2024-08-28 13:54:56.264322	37560fd5-f1b6-4a61-9f50-d46d124d9fb7
1336	12	2024-08-28 13:55:00.536543	8ef307d9-a743-494a-9209-4eec726c1c9a
1337	12	2024-08-28 13:55:01.888463	be30e4ca-3f5f-4eb4-9897-1bd87643be1c
1338	12	2024-08-28 13:55:07.500532	cbed9560-aebf-46c9-a38a-a9f089fd6801
1339	12	2024-08-28 13:55:08.769916	bb73ee07-6c8f-43c1-b9db-7ffb05decd3f
1340	12	2024-08-28 13:55:12.182997	f8820717-3da3-457c-a9c1-b34deb9ae257
1341	12	2024-08-28 13:55:14.280115	768c40b9-0e33-46c5-8dc8-b705d74f3ac3
1342	12	2024-08-28 17:04:17.256328	465ea420-93eb-4671-b012-fe02de923eaf
1343	12	2024-08-28 17:04:20.756394	62a104c5-8aeb-4d2a-ab9c-79bd0cffab5b
1344	12	2024-08-28 17:04:22.746776	4ba3e1f6-c0a4-4357-a96d-0233c1c598ea
1345	12	2024-08-28 17:04:27.168237	669ddf88-b36e-442b-9b3b-0d6121d9144a
1346	12	2024-08-28 17:04:28.515245	02ca475b-5981-4fb7-8065-c08059541b1b
1347	12	2024-08-28 17:04:31.154573	09feebf2-dac6-4d26-b2c0-592f2bdcd843
1348	12	2024-08-28 17:04:32.549864	b4f46442-e735-445e-ba43-602a92c4da19
1349	12	2024-08-28 17:04:37.200268	f71678e7-c26e-4466-b207-ca4cf934c0bf
1350	12	2024-08-28 17:04:38.543829	ce4d6505-7acb-44ba-9085-6970d1a29b2c
1351	12	2024-08-28 17:04:41.548397	a73d7da1-3603-4ecf-be12-377836e21c32
1352	12	2024-08-28 17:04:43.001228	7c09006a-dee6-47a1-999f-66c15f0e575c
1353	12	2024-08-28 17:04:47.099814	e95cdd45-5b14-4b42-ab36-80a1b5df8d06
1354	12	2024-08-28 17:04:48.493406	328dfaa0-1144-4756-ac97-879fcf3e58fd
1355	12	2024-08-28 17:04:52.71913	9679607f-d5f9-4093-a01b-4cdf125d544b
1356	12	2024-08-28 17:04:54.075488	8c098198-4c1a-48b0-b7f9-c0e037e8c4ec
1357	12	2024-08-28 17:04:58.528478	8e06ace8-3334-43b3-9159-4bd8a36d5d90
1358	12	2024-08-28 17:04:59.863992	d1b7f261-b7f9-4309-9a69-0e19bd78bfb5
1359	12	2024-08-28 17:05:05.831087	1206bd98-ae5f-4a93-9fe3-cebfcf10bf26
1360	12	2024-08-28 17:05:07.191134	423dd54a-3c1b-4754-96c7-d20537130a44
1361	12	2024-08-28 17:05:10.916507	d507370f-c812-445d-b7bb-1c78f63f6343
1362	12	2024-08-28 17:05:13.221834	aea95ffd-808f-4678-bf8b-dfe3fefabf5c
1363	12	2024-09-02 14:29:37.901491	4d25f99e-8f0e-4016-be01-699e6fe26982
1364	12	2024-09-02 14:29:42.800672	03e057ae-7f0f-4595-843c-6d3c5399633a
1365	12	2024-09-02 14:29:45.652918	90350b4f-af0d-47b4-bb54-36830923789c
1367	12	2024-09-02 14:29:54.292153	2fced247-eb25-4f85-b0cd-7fba9d3e8998
1366	12	2024-09-02 14:29:52.453333	d745393e-2bc6-4fb5-a7f4-0b241c2a72f1
1368	12	2024-09-02 14:29:57.936466	7751a1b0-3068-44ca-aa50-7c152a675c68
1369	12	2024-09-02 14:29:59.611101	95d9be61-ec88-4e75-b895-d6d3c6a8d05e
1370	12	2024-09-02 14:30:05.913053	92451de1-3c7b-48a6-b747-4050685dfe51
1371	12	2024-09-02 14:30:07.600504	731d6563-f5fc-4d29-8e18-87ff21cd58e6
1372	12	2024-09-02 14:30:11.143492	52511176-20ad-4bc8-bcc2-e8483a50bc52
1373	12	2024-09-02 14:30:12.73349	73fffb73-ef4f-47f7-b419-f59c8adb5fd0
1374	12	2024-09-02 14:30:17.785977	be2cf9d1-9c23-4529-afda-a3c3aef089d5
1375	12	2024-09-02 14:30:19.289805	60883132-10da-4276-a146-42c04a0c3d63
1376	12	2024-09-02 14:30:24.045739	01216f16-8077-4cce-8487-406c228fd33e
1377	12	2024-09-02 14:30:25.560453	217db03c-4ae7-47c1-ad6e-ea7be3ff0351
1378	12	2024-09-02 14:30:30.772216	7d7f27af-75b7-4784-96d5-b6e5486ee131
1379	12	2024-09-02 14:30:32.240278	5496efb1-2e47-4fca-9948-401b98067b02
1380	12	2024-09-02 14:30:38.50083	a4b7b781-a7d2-473f-b978-98678162cdc8
1381	12	2024-09-02 14:30:40.006447	cc6cf614-5ac5-4fcd-86d8-08b39e66083e
1382	12	2024-09-02 14:30:44.247394	cfc09fcf-9cbc-4eab-aff8-515fd5aa6e78
1383	12	2024-09-02 14:30:46.70626	58c184ff-fc3f-49ed-bd92-763f043b6e30
1384	12	2024-09-04 19:34:13.807685	ff49b58a-7367-4e4c-819e-95e7edf3ab62
1385	12	2024-09-04 19:34:16.737684	eff74108-db28-40a4-bf7b-46f9da1e98ec
1386	12	2024-09-04 19:34:18.596012	0f05f26a-6297-446f-9bbc-d96e837f6c43
1387	12	2024-09-04 19:34:22.381977	58cbcbf9-a11d-439a-9b53-3a9ba971f589
1388	12	2024-09-04 19:34:23.559278	efb9c90f-e52a-4790-867e-12d2033a10e0
1389	12	2024-09-04 19:34:25.856926	0bb5e7ed-e8bf-44fe-bf8a-d40954470fd3
1390	12	2024-09-04 19:34:27.049585	67eab59b-66a8-48f2-bec7-8e0a88b3ba6c
1391	12	2024-09-04 19:34:31.164671	f0ab013d-de51-4710-9bd8-39e046b6e730
1392	12	2024-09-04 19:34:32.38432	be5aae1b-ec5d-4911-a52c-8ac464f5b854
1393	12	2024-09-04 19:34:34.975766	a3fdc69f-bd39-4987-8719-eab3786b129e
1394	12	2024-09-04 19:34:36.184092	1d6edbd4-f9ed-4ebb-87b8-8a824b4dfae9
1395	12	2024-09-04 19:34:39.818446	fb47eb34-4809-43c0-bac4-336d5b99272f
1396	12	2024-09-04 19:34:41.000157	43f82e8f-5ef1-4d2c-b0d3-8814af203fe6
1397	12	2024-09-04 19:34:44.939813	23210f17-7ebf-4fec-9090-926a025b7e83
1398	12	2024-09-04 19:34:46.127717	4d0e4fe3-34a4-43dd-b51e-dfcfff0e9c56
1399	12	2024-09-04 19:34:50.15771	a8cb574b-c452-4f1d-89c8-9dbb68cb4cb4
1400	12	2024-09-04 19:34:51.303783	6178d634-d02c-49b7-9a15-1cd676dd975d
1401	12	2024-09-04 19:34:56.244729	db31568d-d9a0-432e-a57c-e7dc42ce4b04
1402	12	2024-09-04 19:34:57.344488	4296f63a-d7db-4291-8362-a91d68732154
1403	12	2024-09-04 19:35:00.439524	78b484a8-7209-40dc-817f-98005f5b9299
1404	12	2024-09-04 19:35:02.676477	511f1c38-9c60-40a8-948e-9b8caef17dbd
1405	12	2024-09-04 20:03:52.21748	6a7c7a4e-7693-42d2-a3a7-fae0e18b0ffa
1406	12	2024-09-04 20:03:55.220456	4cd6f319-fa87-4fe1-bca3-644a63904c67
1407	12	2024-09-04 20:03:56.959259	7058c79f-73fb-4d96-9235-93978865a4fd
1408	12	2024-09-04 20:04:00.844681	4ff418fe-d2d9-470a-b695-d14c9747cb9b
1409	12	2024-09-04 20:04:02.20573	9d3d2382-46f4-4ac7-81e1-bf61b30dda23
1410	12	2024-09-04 20:04:04.532488	e4e0139e-318e-4dd9-be7d-550d93128e88
1411	12	2024-09-04 20:04:05.706835	fc15a143-6f74-4844-bac6-0e06630f08de
1412	12	2024-09-04 20:04:09.51512	11f19171-84cf-4f0d-856d-d3b3b6fd4ae1
1413	12	2024-09-04 20:04:10.713179	cfb043e8-29cf-46c6-b280-7b7a93985e9b
1414	12	2024-09-04 20:04:13.352826	4545a4b8-d64b-4f4e-88e3-56e49566eadd
1415	12	2024-09-04 20:04:14.58056	91030e07-80bb-4e71-81e4-9008fba9fc71
1416	12	2024-09-04 20:04:18.130105	db087a66-84a8-470d-ad77-0912dc9793c9
1417	12	2024-09-04 20:04:19.354296	a6fe975a-239c-4215-a703-30fe9e477e9e
1418	12	2024-09-04 20:04:23.034475	00c72a73-be5b-4e7b-b86a-afdaaa9ec12d
1419	12	2024-09-04 20:04:24.164515	016d0f7b-6dbe-4f4d-8c4a-6b56e733403c
1420	12	2024-09-04 20:04:27.993276	e20a1537-8afe-49ea-a965-a02114c4c8c3
1421	12	2024-09-04 20:04:29.178307	ce082f33-d705-497a-a4ce-6574fcc74a86
1422	12	2024-09-04 20:04:33.944693	c1f8163e-c912-474c-8d1b-3bf94f0eb6a4
1423	12	2024-09-04 20:04:35.126535	bf3fec19-1be9-4f1b-bc41-ba1ad2d908aa
1424	12	2024-09-04 20:04:38.124675	585500b7-802c-477f-a9a2-9d0352a9682c
1425	12	2024-09-04 20:04:39.996469	ad999d63-9ce9-4ee4-b638-ee7e11d59973
1426	12	2024-09-08 11:46:36.844507	b78201d4-f33b-4e36-8a7c-3987d57bb68e
1427	12	2024-09-08 11:46:40.5987	88b4e7cb-3eef-4f13-bb1e-bbc6a93cb63e
1428	12	2024-09-08 11:46:43.019525	9524cfc6-dcc3-405d-9215-0b6997a09f29
1429	12	2024-09-08 11:46:48.684645	79e12ccf-7bb6-4038-84c7-0ba0a977a8cd
1430	12	2024-09-08 11:46:50.460023	8b6eb8c4-c601-473b-8ba7-d528fb467c50
1431	12	2024-09-08 11:46:53.684355	bb0b710e-5eb5-4879-913b-9cc588b554a6
1432	12	2024-09-08 11:46:55.381538	85a1cef9-6694-4aa6-b359-64ea79d69f3c
1433	12	2024-09-08 11:47:01.306628	56073c5e-7b7f-41f3-a4ce-6541efb704e5
1434	12	2024-09-08 11:47:03.038438	14aa4763-4128-4d1e-9448-f46e3097f824
1435	12	2024-09-08 11:47:06.768789	b88db1e7-69ab-45e8-b300-c8e8bc5e2704
1436	12	2024-09-08 11:47:08.537324	bf856568-4fae-4080-b042-56dd0efa7b67
1437	12	2024-09-08 11:47:13.724183	26fdaf1f-12a1-40e2-b392-edc2b285e70d
1438	12	2024-09-08 11:47:15.41511	429f1506-80e1-45f4-92cc-caaf5e19f3d4
1439	12	2024-09-08 11:47:21.021264	b1da6915-fd7a-413e-85fd-14909a5e4b7f
1440	12	2024-09-08 11:47:22.727395	9ee5d4bc-140d-43d3-a2de-24d8b7449173
1441	12	2024-09-08 11:47:28.307596	795ac2e2-e74b-404e-a867-585bdd523785
1442	12	2024-09-08 11:47:30.004393	e9f5f026-1419-4377-bc6f-865c88b8e003
1443	12	2024-09-08 11:47:37.196332	31cfce25-ce45-4569-9af1-9be3e8c5b2df
1444	12	2024-09-08 11:47:38.9404	990aa22b-d367-4071-a062-8f4ccbafec7c
1445	12	2024-09-08 11:47:43.594418	c344e253-c30e-4f34-8be2-2a150c3fe85c
1446	12	2024-09-08 11:47:46.544258	5ccfe83f-d0bc-4035-a826-9e5ae7374422
1447	12	2024-09-08 12:03:05.180529	d8f8858f-0527-4389-8b28-2189f6125f17
1448	12	2024-09-08 12:03:08.343963	897d24d1-a1a0-4605-93af-215ad239329a
1449	12	2024-09-08 12:03:10.187093	519b0ca9-56ff-47cb-9840-d8203b871075
1450	12	2024-09-08 12:03:14.026264	2b01499e-e354-46f0-9eea-a55df1b17eb1
1451	12	2024-09-08 12:03:15.186802	a5ed6b6d-8e97-4e6a-a6d8-219db9ef18e8
1452	12	2024-09-08 12:03:17.317628	8385f7e4-9235-4320-821e-e5a27016d433
1453	12	2024-09-08 12:03:18.416456	b886d362-2388-4c5a-bec2-0632bd729364
1454	12	2024-09-08 12:03:22.262191	059eb56d-67c6-452f-8481-64778c21a695
1455	12	2024-09-08 12:03:23.413806	66c3dd28-e422-4850-a855-b6c9c8cf8e98
1456	12	2024-09-08 12:03:25.916402	f9b808db-aa00-40c4-9e2d-39397d904598
1457	12	2024-09-08 12:03:27.067178	af5b6803-e974-4635-8547-fe1d41381539
1458	12	2024-09-08 12:03:30.486458	82048755-50ff-4caf-901e-441fac1c5755
1459	12	2024-09-08 12:03:31.588865	8c655698-3d6b-4bac-b7c9-468d12bf8dc3
1460	12	2024-09-08 12:03:35.064573	e345b870-33d1-474d-acd2-48e6f26c7029
1461	12	2024-09-08 12:03:36.26866	047fb9f3-062a-4c5a-b798-b8e34d3eb813
1462	12	2024-09-08 12:03:40.308592	bf99e58c-2067-4118-ae3a-581d231decbc
1463	12	2024-09-08 12:03:41.492657	8b76fc52-f7cd-4deb-9d60-bdd4c74fd42a
1464	12	2024-09-08 12:03:46.49505	c28d1d7e-bf33-4544-a769-8bf7b589a8f7
1465	12	2024-09-08 12:03:47.768428	24019204-6b44-42dc-b5c8-280a03ff1317
1466	12	2024-09-08 12:03:50.922837	ebb8e5d1-5883-471a-a1b0-c21c23b3eb41
1467	12	2024-09-08 12:03:52.896574	b1c199de-db3d-4125-be03-56db1e13f4c2
1468	12	2024-09-08 12:07:22.475345	5a540d37-4263-4e2d-bd38-907d04189c81
1469	12	2024-09-08 12:07:28.972916	ec42d797-5f34-42da-9af4-93e68c447eef
1470	12	2024-09-08 12:07:31.873035	1ccd5759-f07b-423a-8705-eb90811a4473
1471	12	2024-09-08 12:07:38.473873	48420d18-c2f3-41d9-a634-3b1a620f7719
1472	12	2024-09-08 12:07:40.156645	15375fa9-fc8e-4b40-a3f6-dc4cee025410
1473	12	2024-09-08 12:07:43.540705	cc8046f4-f6b7-42af-a141-ac259485fe85
1474	12	2024-09-08 12:07:45.163535	eb123b3c-4f06-48ea-b671-ef54752268fd
1475	12	2024-09-08 12:07:50.235896	fce52144-2a3d-49a6-b9d2-e99ab78fc363
1476	12	2024-09-08 12:07:51.792591	a014ddb5-e586-45a4-a894-e7de19a42b2f
1477	12	2024-09-08 12:07:54.852353	d3a8ba30-f785-4a5f-b28f-878177e47882
1479	12	2024-09-08 12:08:00.30082	3d8a8a80-bef0-4691-8122-84fd79bd7195
1478	12	2024-09-08 12:07:56.143915	7cd20a1a-1b54-48bf-8d3d-9cf553e730f3
1480	12	2024-09-08 12:08:01.637439	4e6c4375-ed05-4369-85e4-e713a27b4904
1481	12	2024-09-08 12:08:05.96666	a3655f85-e080-4741-a598-bac05903f21f
1482	12	2024-09-08 12:08:07.247268	14e451d8-e75a-4023-8e8d-df6367f19d35
1483	12	2024-09-08 12:08:11.635831	10d1213e-5ff9-4cf2-8ece-d45edeb169c4
1484	12	2024-09-08 12:08:13.143578	f3ef00cb-58b4-4369-be33-624feadc03d5
1485	12	2024-09-08 12:08:18.613034	e44ca771-1ecc-45db-91cb-fbe0e4db26d5
1486	12	2024-09-08 12:08:19.839747	90347d26-8f25-4db3-8623-0a9bb16dbecd
1487	12	2024-09-08 12:08:23.223677	44e20411-a6db-4cdc-b478-cb7d0573b380
1488	12	2024-09-08 12:08:25.238741	9a4849f6-8bfe-4ca0-b19f-48f275e564f6
1489	12	2024-09-08 12:21:20.507557	a81e21f1-9603-4dbd-ac12-0f44839e844e
1490	12	2024-09-08 12:21:24.6726	f93b69bc-0d07-4839-b918-1dacf9345b66
1491	12	2024-09-08 12:21:27.147491	201d6ba9-498c-4869-b27f-517da6e0e3be
1492	12	2024-09-08 12:21:33.007659	cd2f8b61-4f8f-49c2-bf9f-921d9d7f4d6b
1493	12	2024-09-08 12:21:34.738505	b832c603-db48-43a9-a268-00587dd9d016
1494	12	2024-09-08 12:21:38.160503	94f0c934-12c7-44ac-b2d0-b1521c4247d1
1495	12	2024-09-08 12:21:40.012593	99c92f2f-36c8-4853-9a66-b2dd66984cf1
1496	12	2024-09-08 12:21:46.611586	ac7d7cd8-ae20-4915-ad85-3315b4ce1655
1497	12	2024-09-08 12:21:48.479402	e2df9aa5-e404-4063-b0ed-4c74d3d57d41
1498	12	2024-09-08 12:21:52.352501	d4ab99b9-15a0-4e5c-bbb7-b9ebf0a7bb97
1499	12	2024-09-08 12:21:54.054498	7dd85b8c-5488-4cc9-a2a9-6aa9bdb27d14
1500	12	2024-09-08 12:21:59.492438	30c62637-6841-4e21-b2e2-375b4cbb5ce3
1501	12	2024-09-08 12:22:01.243419	8e68ec02-2f48-4806-a178-827f00e5ce8f
1502	12	2024-09-08 12:22:06.651453	b6abe549-de33-4e81-b565-065881ce72a5
1503	12	2024-09-08 12:22:08.436427	cc730c13-f0ad-4c66-aff8-c88170db9c85
1504	12	2024-09-08 12:22:14.274921	3977e9d0-dc95-4ada-8a82-d442df947ff8
1505	12	2024-09-08 12:22:16.050348	a992df57-9ce9-48de-b568-d35b695bc81d
1506	12	2024-09-08 12:22:23.483467	691377e1-2e4b-4aeb-9fd2-4f7019108006
1507	12	2024-09-08 12:22:25.175276	b27041b7-593c-4220-bc80-09d2269df3c4
1508	12	2024-09-08 12:22:30.035607	5c497dcd-5488-4f8a-88bf-b039b10d400d
1509	12	2024-09-08 12:22:33.022706	a6422023-09d4-451c-82f0-f5fba327b4bb
1510	12	2024-09-15 17:04:59.316556	7992b89a-da77-49eb-8fe0-a4ef714dc423
1511	12	2024-09-15 17:05:02.84457	941712ff-12b5-459d-8a4b-8e76c6a2fada
1512	12	2024-09-15 17:05:04.840459	e1a16627-f917-4671-bde8-1c3c83ded6d8
1513	12	2024-09-15 17:05:08.747018	e2872d45-f5f8-4ee3-bf32-ddb59a686fb3
1514	12	2024-09-15 17:05:09.944363	e556cf2e-2a6f-4b48-b432-5812c7cdc97a
1515	12	2024-09-15 17:05:12.163672	98c9235e-7fa8-4b30-b1bc-9ff52f3a9e18
1516	12	2024-09-15 17:05:13.28342	58dc7012-c68a-4752-ba52-15b8b7fd65d9
1517	12	2024-09-15 17:05:17.146732	2f608f51-d88b-48de-b756-ef7d0e5ae4c8
1518	12	2024-09-15 17:05:18.276662	60e92424-0f3b-43fa-ae52-b4a593b26868
1519	12	2024-09-15 17:05:20.788435	cedae2a2-c421-4a70-bf54-856338887655
1520	12	2024-09-15 17:05:21.889111	fdcd0105-12fc-4bdf-a4df-7871674a159f
1521	12	2024-09-15 17:05:25.284585	c1b6a054-c859-49ee-bc60-45f27a4e65fe
1522	12	2024-09-15 17:05:26.44364	4230cc80-b943-4447-a762-c0e7f6a550e7
1523	12	2024-09-15 17:05:30.046193	a3e6a603-9518-4036-b7ab-aca64a4f6b76
1524	12	2024-09-15 17:05:31.142495	4a099271-15ed-4357-baa8-9786875f61c9
1525	12	2024-09-15 17:05:34.764743	2c3c1f55-81f1-4622-b9f9-34d011063f9c
1526	12	2024-09-15 17:05:35.863926	5cddc452-b61f-4432-b89c-82c1f7a13b85
1527	12	2024-09-15 17:05:40.416248	0f6c0d87-8e47-4734-8b94-978255819e16
1528	12	2024-09-15 17:05:41.491489	e6f02bc6-09b9-4b46-b513-d93984a7a61f
1529	12	2024-09-15 17:05:44.42332	ec1a192e-970c-412a-acef-555049d70a24
1530	12	2024-09-15 17:05:46.257488	0a0ddc5a-639a-4df3-96c4-2e347365b011
1531	12	2024-09-18 20:09:30.552791	ac41aa24-0fa8-45f3-976f-65e1d328cb73
1532	12	2024-09-18 20:09:34.147605	b1d15068-474a-402a-8534-2929c5db3fa1
1533	12	2024-09-18 20:09:36.349231	27d2f69f-aea1-4f93-8eef-85e409463d8c
1534	12	2024-09-18 20:09:41.008323	c287fea8-270c-4bb6-bac6-91a9a241636f
1535	12	2024-09-18 20:09:42.42905	f58bf39e-4bfc-4851-85a3-cb5eceef2721
1536	12	2024-09-18 20:09:45.292464	9b1a763d-8f7e-4fe8-b1ad-c278b7d60730
1537	12	2024-09-18 20:09:46.771396	5749c945-b599-4a5d-825c-c6f03165f29c
1538	12	2024-09-18 20:09:51.592576	faa3804c-6c6b-4f97-a277-cd6a1b113818
1539	12	2024-09-18 20:09:53.01188	9f04fb96-f1b4-46ca-b6b7-4fe44a30721a
1540	12	2024-09-18 20:09:56.107705	e0c74edf-ff7b-4163-9566-30f8ece839c6
1541	12	2024-09-18 20:09:57.526706	8a613b48-f8ab-4b7c-a669-9a99488e989d
1542	12	2024-09-18 20:10:02.151511	bdd97702-e8ad-40fd-a15d-80dc3274c922
1543	12	2024-09-18 20:10:03.653607	1f3a5cd7-0b75-410f-b248-db65c7414fd0
1544	12	2024-09-18 20:10:08.348708	937f1d4f-90ba-4d07-8d0f-2192d1855d25
1545	12	2024-09-18 20:10:09.822929	5572f7d5-f68a-48ef-9a7d-7db786ef31f1
1546	12	2024-09-18 20:10:14.589517	69563fdb-436a-468b-99c5-ba407591e67b
1547	12	2024-09-18 20:10:16.037996	07a09590-829a-45e3-a095-442241a7d8cf
1548	12	2024-09-18 20:10:22.046945	b51dba4a-48c1-428e-8b50-211fedb10e0b
1549	12	2024-09-18 20:10:23.505285	4fcc5fd9-976d-4673-b2cd-5ff4543bf0c8
1550	12	2024-09-18 20:10:27.303759	ffdc132d-c9e8-451d-948d-105d79022ab5
1551	12	2024-09-18 20:10:29.696451	d3ad9581-098a-4326-9d61-e461ea313d1a
1552	12	2024-09-18 20:11:02.401132	517b09b6-7b63-4531-94d5-78f3caa1b3a1
1553	12	2024-09-18 20:11:05.440487	9f85b58a-a8d7-47fc-b193-0f5572b86ae3
1554	12	2024-09-18 20:11:07.310638	59bd9479-f3f5-4a59-b33a-c466d5d656f9
1555	12	2024-09-18 20:11:11.076669	e81536ce-7904-4a61-b016-9236751c230c
1556	12	2024-09-18 20:11:12.332433	4f74cd3a-346e-4704-9dd8-f9a6e94f2d18
1557	12	2024-09-18 20:11:14.664442	82c99a43-eb7d-46fd-ab49-a9ccfa7c8bd3
1558	12	2024-09-18 20:11:15.853844	e485213f-f8bd-4505-88fc-b98be357aaa2
1559	12	2024-09-18 20:11:19.76853	7744ae4d-9f84-4b4c-8257-20cdb5ae4bee
1560	12	2024-09-18 20:11:20.946802	0a2e5a3b-6c9f-4204-8173-cd79984e9803
1561	12	2024-09-18 20:11:23.448418	8f413126-a170-41c8-a094-4b39cf7d929e
1562	12	2024-09-18 20:11:24.623802	4db6c114-1e9a-4bae-ae40-7f8d5ca6520d
1563	12	2024-09-18 20:11:28.172572	02f1d2f9-ad26-485c-a92e-2f0e6db4643d
1564	12	2024-09-18 20:11:29.315381	bdc6b241-acd1-4951-a0ec-b79904cf10de
1565	12	2024-09-18 20:11:32.928629	76d19881-2299-4520-b02d-95a4427163d4
1566	12	2024-09-18 20:11:34.009067	ce7d33ae-a603-4a9f-8834-61c9666d189a
1567	12	2024-09-18 20:11:37.752528	6ffd135a-b17e-40a6-ba50-d212dd30d331
1568	12	2024-09-18 20:11:38.923784	973d9d8c-9f1a-41e1-b1f8-8f0d32809795
1569	12	2024-09-18 20:11:43.723576	0753c1ae-cc2e-4437-9570-f86ffeb366d9
1570	12	2024-09-18 20:11:44.851049	86426b9b-cff8-4847-b620-8b4ee10b5944
1571	12	2024-09-18 20:11:47.865067	2e35964f-9025-417c-a406-c7c4b53c1d47
1572	12	2024-09-18 20:11:49.740044	799a3c8c-ee21-4360-a82c-016cf2254a8d
1573	12	2024-09-18 20:32:24.502676	b537da9d-a503-48b7-b236-52269aab1cd5
1574	12	2024-09-18 20:32:31.727045	8b9d85e2-1f49-4add-b6e6-5dbe12137f46
1575	12	2024-09-18 20:32:34.1005	588224f1-bbea-4812-a8ec-21bc3bd19360
1576	12	2024-09-18 20:32:37.334652	8ff13903-c3b7-47c0-8ee4-b8b379cece0e
1577	12	2024-09-18 20:32:39.011335	106824a5-348e-4fc0-9efc-fdffe306d31a
1578	12	2024-09-18 20:32:44.917058	2a5ea21a-f910-4969-84a2-1aa124797037
1579	12	2024-09-18 20:32:46.848034	3f5569cc-24d3-4ea4-8d9e-0b05f84f2aff
1580	12	2024-09-18 20:32:50.581195	1a3cff22-2298-4014-b445-69538e358834
1581	12	2024-09-18 20:32:52.267433	dc9c679e-6c72-4f52-af98-a50cb66a60ef
1582	12	2024-09-18 20:32:57.545107	86c207c9-489b-4175-b185-9ec4807bad0c
1583	12	2024-09-18 20:32:59.213478	f40f17e4-72b0-4dfd-9061-4e811926e397
1584	12	2024-09-18 20:33:04.524533	a7f29556-7fba-46fc-8cef-c3005c6ff840
1585	12	2024-09-18 20:33:06.19762	ebe1c4fd-52c7-4db6-9ab6-61894e903826
1586	12	2024-09-18 20:33:12.001083	4ce05ee2-e6f1-45ea-ad9b-7b38a678b51b
1587	12	2024-09-18 20:33:13.718003	8274ae36-6f11-4f63-9593-362438eaf0cb
1588	12	2024-09-18 20:33:20.979531	2581d94d-eb9c-4cc8-b1cc-d47d145ce11a
1589	12	2024-09-18 20:33:22.623417	75414734-51be-47cb-bb95-aafcac3eb677
1591	12	2024-09-18 20:33:30.432979	09bcc687-a4e5-4707-94c5-2c4d273a9cc8
1590	12	2024-09-18 20:33:27.373131	f67a3367-d3a0-4a4b-b582-95db8341ffa1
1592	12	2024-09-18 20:33:32.153824	0e514adf-9cf2-48d1-91f4-d84f8bc69871
1593	12	2024-09-18 20:33:34.676351	8d2d705f-a048-47b9-8a9c-871ce620b068
1594	12	2024-09-19 17:58:38.615029	61f25783-57c5-4f9f-9da6-6ee13de6654b
1595	12	2024-09-19 17:58:44.329619	80399121-2568-4420-9081-832f15970e9a
1596	12	2024-09-19 17:58:46.100831	f5dd52c4-05e8-4165-b80a-882a40dc85f1
1597	12	2024-09-19 17:58:48.575978	7e5324ed-52af-43e8-923f-4cc6151fa7bd
1598	12	2024-09-19 17:58:49.822474	6e337eda-1a9b-4ae3-af88-f3c90d984e00
1599	12	2024-09-19 17:58:59.959135	1aa9ca91-60c5-468a-a787-1d7bb975bb23
1600	12	2024-09-19 17:59:01.338134	40ff2b29-d676-4d34-b347-0f5292a38661
1601	12	2024-09-19 17:59:04.754404	3986d4d1-8355-43e8-9c3a-431e082b79c6
1602	12	2024-09-19 17:59:06.108333	b772ba8c-f06f-4fea-9ba7-6a3232941c27
1603	12	2024-09-19 17:59:10.34727	a1728b5b-24dc-4b49-8b0e-827e335a5ff6
1604	12	2024-09-19 17:59:11.680328	71154d80-7f6b-4fa1-9ec5-373368b353e4
1605	12	2024-09-19 17:59:15.867418	02e5e313-7567-4a96-b6c1-76a21b0c8a2a
1606	12	2024-09-19 17:59:17.244971	89575b89-54d8-4ade-bfb6-ebbd648703e1
1607	12	2024-09-19 17:59:21.604284	1df39a02-1aa3-4132-bdc5-48729d87dc1b
1608	12	2024-09-19 17:59:22.942499	def511db-c117-4556-88ef-1f29473be1fb
1609	12	2024-09-19 17:59:28.527329	5d02b1ef-6ce3-4717-af92-39429947332e
1610	12	2024-09-19 17:59:29.826764	70a240f8-d5a2-4088-9948-b6561c6d368e
1611	12	2024-09-19 17:59:34.048624	a2b3cdaf-b00d-4def-a136-8b8240e8ded0
1612	12	2024-09-19 17:59:36.79845	77d12f24-b3f0-454c-b046-6f613893f7a5
1613	12	2024-09-19 17:59:38.175766	f25cd8e2-9cb6-481b-8b37-78135b620b0c
1614	12	2024-09-19 17:59:40.159477	a5754c17-48b2-40e2-bdd5-f599bf8a3859
1615	12	2024-09-19 18:22:06.092327	4c7d0e2a-ee88-45c9-8e84-47aae4fea600
1616	12	2024-09-19 18:22:12.737602	3db11df4-9ea2-4dfe-b7c7-16940a26645c
1617	12	2024-09-19 18:22:14.812632	6f3343b3-2a80-4b18-afd1-7ec894503c64
1618	12	2024-09-19 18:22:17.944199	82e08972-7eef-4d8b-af61-248f595a4055
1619	12	2024-09-19 18:22:19.611474	52b1bfbb-043e-4bf2-b766-5321c56e97a6
1620	12	2024-09-19 18:22:25.392583	6fa883c2-912d-4b24-9ec7-809602aab864
1621	12	2024-09-19 18:22:27.026404	eee096b0-8fba-4209-8bf6-23b39fbeed61
1622	12	2024-09-19 18:22:30.840783	d63b219c-27aa-4fdc-835e-67982e96a94a
1623	12	2024-09-19 18:22:32.471288	e82ea2ed-fdcd-4e83-8e39-ed77c8b7bc0c
1624	12	2024-09-19 18:22:37.624173	fb740f34-eb23-413f-be02-93e83dd63302
1625	12	2024-09-19 18:22:39.230912	98a18042-d588-40e8-a2ea-8e31fd8990e0
1626	12	2024-09-19 18:22:44.355411	d96d73e5-7438-43d9-9094-3a6ba414315b
1627	12	2024-09-19 18:22:46.011878	177fca87-05f8-4688-8db4-77c0cd41ccc0
1628	12	2024-09-19 18:22:51.431832	025f1369-8a5f-4c1f-8418-9f69e3f8b43a
1629	12	2024-09-19 18:22:53.021547	84cab535-f99d-496a-97bc-5300e4997d57
1630	12	2024-09-19 18:22:59.939734	bbbd7ea5-4481-460b-910b-56c3e080d2af
1631	12	2024-09-19 18:23:02.28159	d821ddfd-c0f8-4080-a38b-2ee36554955d
1632	12	2024-09-19 18:23:07.061261	4beb30c3-9fa5-482d-9e15-cf0b85600ad8
1633	12	2024-09-19 18:23:09.858298	5f346079-c309-4461-92ce-ac02dcc1f7a8
1634	12	2024-09-19 18:23:11.55299	bfcc512f-285a-4a4d-8c1a-7c03949cf9d0
1635	12	2024-09-19 18:23:14.066019	076f60ad-6f40-4561-99b3-1500e52a3c3f
1636	12	2024-09-19 18:35:19.99259	f19d43b8-57ef-40ba-91d7-2d6d5327ea7d
1637	12	2024-09-19 18:35:26.638615	fba57c8d-8063-47ae-92e8-74d1c8284dea
1638	12	2024-09-19 18:35:28.777471	be1b4072-c712-43d6-bbf4-5c1118420198
1639	12	2024-09-19 18:35:32.35635	9d21e9d2-e5df-464d-8a59-956ea459d36b
1640	12	2024-09-19 18:35:33.937385	8a1618bd-1c88-4d04-a44d-1da9f4cb7edb
1641	12	2024-09-19 18:35:39.547968	2701a039-373d-4207-acf1-5fde75c65b5e
1642	12	2024-09-19 18:35:41.145292	198c8ed6-f48a-459c-b32a-1bcb6ed393d5
1643	12	2024-09-19 18:35:44.659595	4801ad83-0dd9-4ecd-9638-dbd56d2e590f
1644	12	2024-09-19 18:35:46.260388	e52b4ec9-1a83-41aa-8e73-ac135f1b6c8f
1645	12	2024-09-19 18:35:51.224482	911f4676-b9ed-4cb3-b58f-3d88694e4c2d
1646	12	2024-09-19 18:35:52.810288	e3ce9a89-67e3-444e-881d-a0481068e599
1647	12	2024-09-19 18:35:57.798931	e11a78c4-103e-443a-b1fb-92a0c3cd38d8
1648	12	2024-09-19 18:35:59.404348	02d1b4dd-583e-48f4-b035-925277f5ce92
1649	12	2024-09-19 18:36:04.96389	2a60096b-0edc-4ba2-bda8-620557db92c4
1650	12	2024-09-19 18:36:06.528181	f1e2c17d-98a2-49fa-bacb-e26d113c8bb9
1651	12	2024-09-19 18:36:13.327813	0c26b195-aa7c-4186-ad7f-efbe4b08f856
1652	12	2024-09-19 18:36:14.857651	f6f9132e-ad03-4159-904f-c37895cc3079
1653	12	2024-09-19 18:36:19.220797	3feabbf5-57da-4b3c-b116-03677fba5140
1654	12	2024-09-19 18:36:22.011435	d9ad9abd-84c1-400d-90f6-29a79559ea30
1655	12	2024-09-19 18:36:23.640754	60024a88-1927-40ad-915f-ffa550e4f871
1656	12	2024-09-19 18:36:26.025605	36a092c3-bf0a-41ff-a6f2-f71b3d0c3c95
1657	12	2024-09-19 18:38:32.409261	74081e69-e4f4-4380-8e8e-afc08e6ee774
1658	12	2024-09-19 18:38:37.690094	0d96d484-194b-41bd-a69d-5024a5df7902
1659	12	2024-09-19 18:38:39.408339	fd1235a4-ee63-4a0c-b4cf-b202a1039c2d
1660	12	2024-09-19 18:38:41.820351	651c5da1-0ae6-4cfe-839e-86bd3316c15a
1661	12	2024-09-19 18:38:43.034202	28d5a66b-8144-435c-b714-0e9b1040df22
1662	12	2024-09-19 18:38:46.876606	3d462138-157d-4e4a-baf3-d8d13dd96910
1663	12	2024-09-19 18:38:48.000808	ebab1cb4-dd7e-49e3-a236-4bbaa542f81c
1664	12	2024-09-19 18:38:50.469179	c56d5d26-98fd-4555-b092-a26b4b42a1a8
1665	12	2024-09-19 18:38:51.621826	cf5f40f4-bb0b-4b5f-8bd1-6eca98f2c833
1666	12	2024-09-19 18:38:55.057476	0b036d20-88e0-4058-bcf0-8bdc213a110d
1667	12	2024-09-19 18:38:56.185007	a87cfaff-39b8-4b6e-9d9a-e8aed6bfbc42
1668	12	2024-09-19 18:38:59.600758	1ceb1375-41ec-448c-bf18-ba36c5525b2d
1669	12	2024-09-19 18:39:00.907117	076ef1dc-5ccd-40a6-b54a-3fffc3e9ac98
1670	12	2024-09-19 18:39:05.012582	f0256cec-730f-4bf4-a0ec-84117e72f789
1671	12	2024-09-19 18:39:06.180242	862ef53d-56ea-454e-8bba-457a2b2f6f14
1672	12	2024-09-19 18:39:10.872758	3cd2cdd9-87a0-438f-a9a6-a6022d68c29e
1673	12	2024-09-19 18:39:12.018177	e2fa8c36-6a38-4531-b1b6-96cb80b50070
1674	12	2024-09-19 18:39:15.134752	ac97d2db-78d8-4246-81ca-c99ae12f1e8a
1675	12	2024-09-19 18:39:17.04388	8db219b8-3adf-4777-9928-c6581761194d
1676	12	2024-09-19 18:39:18.213628	7c5e4def-5c07-4ae8-aaa2-006771331f76
1677	12	2024-09-19 18:39:19.853163	5fa6cc85-ba0a-4878-9bbe-52d32ebada84
1678	12	2024-09-20 11:45:15.340243	a040c831-dbec-4ab5-909a-4dc77d67516d
1679	12	2024-09-20 11:45:20.44855	c21f1465-6a5c-4c4f-bb6f-9b5069bee3c8
1680	12	2024-09-20 11:45:22.092989	638d6a66-69db-443f-9ca9-2538d2431eb4
1681	12	2024-09-20 11:45:24.367119	ea8b0cdf-0d40-4ea2-b9b1-e811e8dbef67
1682	12	2024-09-20 11:45:25.516897	6a8be8e3-32d1-4c54-97cc-9ecc6be223f8
1683	12	2024-09-20 11:45:29.359884	df7ac4db-1571-40e1-8a8d-4eca075db303
1684	12	2024-09-20 11:45:30.635257	1c3fc274-75b4-4513-b3ff-c464bcb3bffb
1685	12	2024-09-20 11:45:33.18814	869961c9-65d8-4f18-92a1-1aae0a97cb73
1686	12	2024-09-20 11:45:34.29127	4a6ccf51-ba08-4649-8dcb-13b819b9157e
1687	12	2024-09-20 11:45:37.669816	dbde98f4-c194-40b1-8ebe-269fb092d305
1688	12	2024-09-20 11:45:38.884405	3c29b0f1-8944-453c-a01b-d537086b1f89
1689	12	2024-09-20 11:45:42.464575	a146910e-c1c6-436a-8635-73cd797eeb91
1690	12	2024-09-20 11:45:43.567385	fdd0e48c-8b77-475c-a3ec-c021cc162841
1691	12	2024-09-20 11:45:47.227276	c257491e-331d-4a00-99a3-e264887ebe39
1692	12	2024-09-20 11:45:48.320401	b70f6777-f7ff-4104-87a3-5414d74418b4
1693	12	2024-09-20 11:45:52.897826	5047be80-3411-445d-b067-98ea2cb1e5a2
1694	12	2024-09-20 11:45:53.983618	f8f97d57-2e1e-44bd-8eaa-938f5ed35e04
1695	12	2024-09-20 11:45:56.901383	716556ee-521b-47db-80fb-f3739e98de06
1696	12	2024-09-20 11:45:58.728414	a275f1a6-6251-450f-b06a-c0a9018c14d1
1697	12	2024-09-20 11:45:59.841055	f14c3b1d-8aef-487b-bf68-f6731cbabee5
1698	12	2024-09-20 11:46:01.571255	b4d2bddc-ccbc-4f05-b0cc-90f282885515
1699	12	2024-09-22 13:09:35.509032	45f0232a-50a8-4829-ae84-5a87f96317fc
1700	12	2024-09-22 13:09:40.680505	5ebe9190-d325-45ef-accc-eb8844359021
1701	12	2024-09-22 13:09:42.27867	b63f8eb5-bbdc-41dd-b603-f6455f3f4238
1703	12	2024-09-22 13:09:45.546151	989a0b5d-d4bd-47b8-9e4b-42154de53310
1702	12	2024-09-22 13:09:44.452385	8d42171b-ca18-41ab-aab5-90e9f52cfdd3
1704	12	2024-09-22 13:09:49.513379	496aa04f-231a-450b-8e1f-d4bb56b3223f
1705	12	2024-09-22 13:09:50.602967	3e7f3c76-1d89-4494-8993-6594ee78293a
1706	12	2024-09-22 13:09:53.089407	05bbec8a-368e-465e-9fea-b9f4cfb6b03e
1707	12	2024-09-22 13:09:54.160941	85ad8152-e428-4ba4-b7ea-3280c4051723
1708	12	2024-09-22 13:09:57.664046	6e330c81-b6ef-4cca-a174-70ac72d5fd3d
1709	12	2024-09-22 13:09:58.750606	48a1f2ff-bfd5-4470-a94d-a0d08424793c
1710	12	2024-09-22 13:10:02.634201	484f746c-0ccb-419d-a178-5b4da0feac1c
1711	12	2024-09-22 13:10:04.008322	eeac0ac4-6620-47df-9d46-d628ee5a3c91
1712	12	2024-09-22 13:10:07.967792	60b8a739-2fc5-4a7d-aeb7-584c629da39b
1713	12	2024-09-22 13:10:09.111889	bf3163db-df0e-4b5e-b66a-ace626f26a46
1714	12	2024-09-22 13:10:13.768558	84115b7f-e96d-4c09-9f23-4f3e9a36a597
1715	12	2024-09-22 13:10:14.866889	d448efd2-fdf2-4a5c-9992-9348b1d31541
1716	12	2024-09-22 13:10:17.801314	f717f170-57df-4473-89ef-5fd9bff75777
1717	12	2024-09-22 13:10:19.701945	91f0bbcf-b66c-49f7-916d-7a00c9caf12c
1718	12	2024-09-22 13:10:20.831015	865c5658-1639-4c8c-b56a-d71851cce8da
1719	12	2024-09-22 13:10:22.568043	00c557ea-d5e4-4faa-9fb8-42871a720816
1720	12	2024-10-07 15:34:27.553718	fad0bf9b-703c-4b94-ae4d-1c589e3a6db4
1721	12	2024-10-07 15:34:32.68455	ae624261-17c6-4c2d-be69-2c5a9a8e79b3
1722	12	2024-10-07 15:34:34.306035	0a2adce9-79f7-468d-9896-ae605e980cb8
1723	12	2024-10-07 15:34:36.424707	bb5abfe4-e56e-45db-9643-5d762e9c0649
1724	12	2024-10-07 15:34:37.499753	077db0dc-e55d-4c7d-8531-744344641be7
1725	12	2024-10-07 15:34:41.196449	f7e45c6c-5c36-4ca0-a297-2a081c60f8cc
1726	12	2024-10-07 15:34:42.281185	7dfb9976-40c7-4a74-8091-0e5c747677f0
1727	12	2024-10-07 15:34:44.717592	12b7ceed-80a7-462a-949b-e15c97de9fea
1728	12	2024-10-07 15:34:45.75389	52e8a095-5c2e-4e0b-a8b3-7caace293fda
1729	12	2024-10-07 15:34:48.999184	e9c27353-9a0f-42f3-8d68-ea54d0af4a4f
1730	12	2024-10-07 15:34:50.048398	d7e089fd-b66b-46bb-9222-944a46777754
1731	12	2024-10-07 15:34:53.322308	b9dc894e-763e-4019-9ede-41211500cc1e
1732	12	2024-10-07 15:34:54.371877	529c8a9c-fd4b-4e37-abb4-707bfb7b6c7c
1733	12	2024-10-07 15:34:57.952479	65c787e0-48c4-430b-a849-d289aea6e714
1734	12	2024-10-07 15:34:58.991447	d00ee67d-22b1-42ae-a236-4d2c5590b38f
1735	12	2024-10-07 15:35:03.891806	c32096f6-a1fa-418a-98c9-9206d7327094
1736	12	2024-10-07 15:35:05.038739	eae0b092-d5c1-4bfc-8810-5b3bbb0e287c
1737	12	2024-10-07 15:35:08.109926	a2149518-38f5-4e10-995d-4661eba46982
1738	12	2024-10-07 15:35:09.891953	b5a57677-cd91-43c9-a768-1ff37d0b522b
1739	12	2024-10-07 15:35:10.990944	10e15df7-53d5-449f-983e-3e1e77457925
1740	12	2024-10-07 15:35:12.676306	0a7d9b4b-f5d5-44a5-a33d-5403316aab41
1741	12	2024-10-11 09:29:33.771839	5c42db8e-d15e-40f8-b2e8-08c85682bb05
1742	12	2024-10-11 09:29:37.469904	1fc9648e-a35e-4b79-94ef-392017d6133b
1743	12	2024-10-11 09:29:39.655326	c3820dab-b8a1-438b-afbc-fe7a5dbf1c1e
1744	12	2024-10-11 09:29:44.903439	db346818-288a-41f3-9ed8-6bada57b6339
1745	12	2024-10-11 09:29:46.499111	6fd500a6-5f02-4292-9586-3c441dc31c9c
1746	12	2024-10-11 09:29:49.529609	a1597a30-fb7f-4e93-8602-cc76ccad1d22
1747	12	2024-10-11 09:29:51.109961	76e834d7-17bc-4f81-b214-bdf6f580ec64
1748	12	2024-10-11 09:29:56.730132	5cfa84f0-e04c-47db-a0bd-b9e15bc856b8
1749	12	2024-10-11 09:29:58.300919	4d9defa0-458c-4483-ae62-2f76c51df4ec
1750	12	2024-10-11 09:30:02.156701	821be36a-8a6a-4bf4-990c-7414e7a11299
1751	12	2024-10-11 09:30:04.096165	1dc0eccc-3c58-4664-a845-65566e5db3c6
1752	12	2024-10-11 09:30:09.372777	19ed3730-0950-41f8-b656-01f5ea0300cd
1753	12	2024-10-11 09:30:10.973755	58509e63-dcba-401d-bcf5-6069ea33b779
1754	12	2024-10-11 09:30:16.103575	618b6b09-5a0f-4e94-934d-738eaa1111e8
1755	12	2024-10-11 09:30:17.692262	b7a11627-ea69-4c0b-b74c-28271ccfcb04
1756	12	2024-10-11 09:30:23.150493	311f6763-8573-4e21-b813-bd51058c9ab8
1757	12	2024-10-11 09:30:24.787001	7fc26fba-428f-4a30-b49d-27cd54023061
1758	12	2024-10-11 09:30:31.770244	3909ad8b-7d74-4bb4-aa28-66a5431f33e2
1759	12	2024-10-11 09:30:33.352874	3702a312-4b6c-424b-8634-741932329968
1760	12	2024-10-11 09:30:37.917644	0aacf802-2c7f-40df-a0bb-309ca04d4b42
1761	12	2024-10-11 09:30:40.691972	a27f8f51-161a-4a09-91ad-b9b7a2c70cf4
1762	12	2024-10-14 13:15:42.834687	48819fd7-7553-47af-8905-6ff35ba03cfb
1763	12	2024-10-14 13:15:46.939083	5b04569b-2908-4e43-be32-fa6a9a7006ce
1764	12	2024-10-14 13:15:49.292113	7f11ff90-4438-4ce8-a785-b25714237722
1765	12	2024-10-14 13:15:54.6731	32cbe602-a364-4aed-9f6e-a8cf4aea2aad
1766	12	2024-10-14 13:15:56.359798	fee20c5f-b6d2-4797-b0ff-416e1b11e1a1
1767	12	2024-10-14 13:15:59.573034	87e5f49d-44d4-4555-8e6c-eb9b09b63175
1768	12	2024-10-14 13:16:01.233684	a5368da5-123c-426f-8baa-cca113c19e26
1769	12	2024-10-14 13:16:07.20831	6a85b0f2-996a-432b-b0eb-5ecc08c9f4e7
1770	12	2024-10-14 13:16:08.8828	3cafbe72-b8f5-47d1-a768-5acad0091cc0
1771	12	2024-10-14 13:16:12.603498	3e802f86-d51c-458a-a6e0-20b0e67cb8d3
1772	12	2024-10-14 13:16:14.258714	67d3b602-0ef7-46b9-aa06-17c2f2198667
1773	12	2024-10-14 13:16:19.462798	ca510c07-b9b4-4a60-9eb3-a27803d38109
1774	12	2024-10-14 13:16:21.121716	30122e57-ab08-457d-bbd6-eec8368aef89
1775	12	2024-10-14 13:16:26.463662	083f4acf-22e3-423c-a243-d6f8642b02d9
1776	12	2024-10-14 13:16:28.111509	93d4cf79-446e-45a5-a9ec-6896b630bdcd
1777	12	2024-10-14 13:16:33.71553	cd8a8651-e6b6-4da7-b759-47ecd4db1ecf
1778	12	2024-10-14 13:16:35.351015	7d33f031-85b8-4691-b02a-6ba59fc0b980
1779	12	2024-10-14 13:16:42.688519	34020d7c-ab74-47ea-b4c9-5f05dcbdb044
1780	12	2024-10-14 13:16:44.320443	43718c5e-03a3-40b9-b345-c50479278c1f
1781	12	2024-10-14 13:16:48.911791	3c912e78-e7f7-408e-a4f7-28faef8297ac
1782	12	2024-10-14 13:16:51.763324	e14fe72c-73d9-4eee-a0cc-3d16ab2b74ce
1783	12	2024-10-14 13:56:58.77079	a9b32d83-8097-4b95-b973-572d0a7cb53a
1784	12	2024-10-14 13:57:01.982672	fe9ced1d-f899-40d8-8bb7-62c4c791f754
1785	12	2024-10-14 13:57:03.784473	2510f32e-9274-4f3b-9a38-1e7f3f287124
1786	12	2024-10-14 13:57:07.412328	c402b0e2-36e1-4082-a6e2-4aae76d9e4be
1787	12	2024-10-14 13:57:08.545352	2e079d3e-f576-4040-bc8b-c55c1a4c6920
1788	12	2024-10-14 13:57:10.77859	4303009d-abc2-4ef7-90b6-d080f8c8e930
1789	12	2024-10-14 13:57:11.896804	ebca439d-3b47-4a13-b5c2-ca2c8b166d55
1790	12	2024-10-14 13:57:15.704573	ffc88c1b-769e-450c-920a-66a3b512483b
1791	12	2024-10-14 13:57:16.818178	34b59b69-6e76-4cc0-b6de-a3f6cedb1ce5
1792	12	2024-10-14 13:57:19.384381	59b0a3a7-1c0b-4372-9d82-953d9a661963
1793	12	2024-10-14 13:57:20.604974	3bd941af-e0e8-4daf-a366-abc1a91b1b07
1794	12	2024-10-14 13:57:24.114674	7f364570-7853-4cd2-abf6-781c9d7382e4
1795	12	2024-10-14 13:57:25.226311	7462d130-daca-4983-8b47-0b31d4783d35
1796	12	2024-10-14 13:57:28.722648	9f79ab31-96c4-43cc-8163-7d96a0680080
1797	12	2024-10-14 13:57:29.893435	87fb55c3-53c5-485b-ae93-d1296af930a0
1798	12	2024-10-14 13:57:33.647257	d0041396-dbe2-4329-a0d3-f2e234fd4e16
1799	12	2024-10-14 13:57:34.728096	810421d7-02b2-4d7f-9596-f867d314ca15
1800	12	2024-10-14 13:57:39.350693	14e7e903-178f-4069-8ff7-dbd3cc6c5426
1801	12	2024-10-14 13:57:40.463068	e9ed87b0-b1b0-4ae2-8a36-427c3f5d1250
1802	12	2024-10-14 13:57:43.426341	c855ebec-5ccf-4da3-92eb-65cb8e4c86d4
1803	12	2024-10-14 13:57:45.291075	4c7764ba-55d8-4e16-bb11-e0249beebe70
1804	12	2024-10-14 13:59:12.598653	7a1c65bb-18a6-47ef-b922-12d901e374d1
1805	12	2024-10-14 13:59:15.600405	e48e2e64-b1d9-4183-9897-2156f5672577
1806	12	2024-10-14 13:59:17.476579	06299482-7ac3-4120-9c32-4dfc02a06135
1807	12	2024-10-14 13:59:21.091346	8c42a584-f041-4752-b96a-7167c73f32e0
1808	12	2024-10-14 13:59:22.240891	3cd72f54-a162-4816-ba9c-3aa147cfa2d9
1809	12	2024-10-14 13:59:24.468409	2882d3c9-ef4c-4853-9e27-292ab8d8409e
1810	12	2024-10-14 13:59:25.568054	09698295-0f18-4911-8f26-707802aa2ac5
1811	12	2024-10-14 13:59:29.317084	38e9f81f-5209-468c-9571-569751662ace
1812	12	2024-10-14 13:59:30.412095	c3af458a-203f-4ce9-bb92-bc2aa064d0fa
1813	12	2024-10-14 13:59:32.833261	199d4345-eb04-41e0-aa4b-56e797204a87
1815	12	2024-10-14 13:59:37.26456	dbd311a7-e50c-4220-bc0f-b20714e4609a
1814	12	2024-10-14 13:59:33.923057	00ca3e01-e2ec-45bb-8b41-6d31eed0f14d
1816	12	2024-10-14 13:59:38.357071	6be2142a-ac90-4257-889b-19f620e49b1e
1817	12	2024-10-14 13:59:41.70354	2b888dc1-101e-4678-b868-413c894d3260
1818	12	2024-10-14 13:59:42.851165	08a4abb9-46ba-4b83-b350-aad1b0a90dbd
1819	12	2024-10-14 13:59:46.514771	b3059f9d-3119-461e-a8df-8e0ff2d9cee9
1820	12	2024-10-14 13:59:47.566198	ba96620f-c948-453e-9bb8-2f72399af719
1821	12	2024-10-14 13:59:52.175902	202d90fa-1644-4330-800b-a1519b53d0c5
1822	12	2024-10-14 13:59:53.280075	c6ccb04d-57a5-49ac-bccd-b96316bc1a08
1823	12	2024-10-14 13:59:56.320178	d2b7e904-bc88-439c-b074-cba36c0ac6fd
1824	12	2024-10-14 13:59:58.256411	c4c12477-845f-4158-8908-e3b85cf00163
1825	12	2024-10-17 17:29:59.505146	fdc66d8d-72c3-455c-b395-708aca079b55
1826	12	2024-10-17 17:30:07.177124	eb22739f-75a2-4830-9572-0531fc6a770a
1827	12	2024-10-17 17:30:08.984577	5376c6f4-f06f-4d24-b55c-95d1e31d8e28
1828	12	2024-10-17 17:30:12.207478	9c774a23-80ea-4399-b4d3-181f89a4780e
1829	12	2024-10-17 17:30:13.692486	ffcdbe56-fb72-4e4d-9751-08ab6fe57c77
1830	12	2024-10-17 17:30:18.574495	ff8e1b82-56d4-441c-bdd1-c7a6cc5888e8
1831	12	2024-10-17 17:30:19.921757	3f58872e-a468-4dcb-aba4-aa23a7c9f5b0
1832	12	2024-10-17 17:30:22.748539	f6f6fdb9-9b65-4320-9c8e-7541063d39dd
1833	12	2024-10-17 17:30:23.992087	063c259d-9d89-4e43-a552-0b659190560c
1834	12	2024-10-17 17:30:27.809906	412e9af2-5f35-4a64-aa90-f734bf24431e
1835	12	2024-10-17 17:30:29.101943	77668d71-bf10-410b-bf9a-f61507118326
1836	12	2024-10-17 17:30:32.85151	f945c348-6cff-44dc-b41f-b2d9edd7acce
1837	12	2024-10-17 17:30:34.171727	758a5b25-3a07-472f-b499-2af8f9e14175
1838	12	2024-10-17 17:30:38.243372	bc6f6b13-51ea-46ef-aaa0-3af60ecf9dd0
1839	12	2024-10-17 17:30:39.435525	a8e9967f-9bda-436f-a26c-921d1016ef7c
1840	12	2024-10-17 17:30:44.385025	6b7578ef-11d3-4508-b6cc-7ca7eb956d2c
1841	12	2024-10-17 17:30:45.565715	5839a60e-af12-4949-a197-8d4ccbca5a98
1842	12	2024-10-17 17:30:48.85385	1609e336-0d27-43bb-a64e-5aae20b114f9
1843	12	2024-10-17 17:30:50.719543	49b75220-437e-4360-97e5-87ed3ec67473
1844	12	2024-10-17 17:30:51.834941	45983224-052a-479a-903f-2601d0093377
1845	12	2024-10-17 17:30:53.668397	9c960ca3-cae1-471b-91c1-be30fdccf5a3
1846	12	2024-10-17 17:31:05.268849	e4157197-532d-4a6e-a75d-f07233919e30
1847	12	2024-10-17 17:31:09.52293	68460728-1224-4f79-9c5b-298a6082ef99
1848	12	2024-10-17 17:31:11.991487	9830de42-1994-4415-bf23-ec23f723913c
1849	12	2024-10-17 17:31:17.701056	d219e1cc-6bdf-4cb3-88f9-c98d7598ac27
1850	12	2024-10-17 17:31:19.461542	54f47465-5175-4cbb-90a1-46eb3fe5415c
1851	12	2024-10-17 17:31:22.770034	62f81f9a-c7fe-4b28-9284-e5342960f0b4
1852	12	2024-10-17 17:31:24.5047	21832822-e95e-46a0-b885-d5dd35756d7b
1853	12	2024-10-17 17:31:30.608782	197837b0-ab23-4ea3-83e4-828082069216
1854	12	2024-10-17 17:31:32.370192	a1c74ea2-07a0-4d5e-a2b2-89915a8ac9b2
1855	12	2024-10-17 17:31:36.232408	04af0426-d5a5-49e7-acb9-e9a824960582
1856	12	2024-10-17 17:31:37.941542	2f8c39bd-8ea5-4d6b-ac58-cec0665e4b4d
1857	12	2024-10-17 17:31:43.377746	193cd49f-c079-4103-8508-5e0c909e575f
1858	12	2024-10-17 17:31:45.099172	a1b79f86-dab0-4e55-aaa5-4a7311cfed4a
1859	12	2024-10-17 17:31:50.479152	47dbc087-3a06-4701-a5cf-fd36e23e4e4e
1860	12	2024-10-17 17:31:52.181605	76e3eafa-0197-4c50-b0fd-147349dccb5e
1861	12	2024-10-17 17:31:58.15811	80df16be-776f-477f-a4a4-c32210c55f70
1862	12	2024-10-17 17:31:59.869583	d737b7a5-77a9-4756-9da6-f30b54db51c0
1863	12	2024-10-17 17:32:07.474408	85281ee2-156c-40c2-bd8d-c36a09f9b4b0
1864	12	2024-10-17 17:32:09.165799	2251ddd1-b981-41bc-b37d-4ba786d212b3
1865	12	2024-10-17 17:32:13.914332	3f42a860-35df-4f1a-9a87-8480c3d67159
1866	12	2024-10-17 17:32:16.843222	79294085-3bf9-4251-aa21-4efdbfe4aca6
1867	12	2024-10-22 12:24:03.548357	e3c02884-b96e-4173-b11b-15210b2a0639
1868	12	2024-10-22 12:24:06.58046	19c42674-422f-4365-9670-1ba64f2ce020
1869	12	2024-10-22 12:24:08.479585	37965177-0f63-4eda-a6b4-924db2602e18
1870	12	2024-10-22 12:24:12.400634	9abf7fd9-911a-4df3-8e44-e4de26bf82cc
1871	12	2024-10-22 12:24:13.569009	8868777a-e824-4fe4-ab38-16d79d696bb3
1872	12	2024-10-22 12:24:15.866803	763cc652-0b3b-43ba-a953-a6f17365304e
1873	12	2024-10-22 12:24:17.037099	e45982d6-f3fe-406b-bf22-466f45f5f570
1874	12	2024-10-22 12:24:20.962183	dc800ccf-cc47-492d-be1e-91593b8538c0
1875	12	2024-10-22 12:24:22.136282	ad3a709a-5020-465e-90fd-fc09dc486899
1876	12	2024-10-22 12:24:24.688233	5584da97-3b10-4120-8a4d-2a12a6d39c1a
1877	12	2024-10-22 12:24:25.936368	2372c234-4b35-4a05-8564-9baea87ba885
1878	12	2024-10-22 12:24:29.509851	6e7aff79-a711-4545-a3ae-9d1a047f53fa
1879	12	2024-10-22 12:24:30.737	b7b9a26c-79ba-4964-8235-bdcc1df4e504
1880	12	2024-10-22 12:24:34.244699	3828b47f-4336-469d-bc1e-1363de644474
1881	12	2024-10-22 12:24:35.342093	bbd7a734-102f-4903-a094-19fcc382e8ab
1882	12	2024-10-22 12:24:39.120669	288252ff-ee75-4f9a-af2b-d35d76b7d4ad
1883	12	2024-10-22 12:24:40.23442	392bc698-0c9e-44d8-9864-81a9f5eb507b
1884	12	2024-10-22 12:24:44.916781	cd41e0b9-5c7a-41b7-a5c7-e7bdca22c695
1885	12	2024-10-22 12:24:46.018226	6a629f7b-5e1c-46ef-86ee-6b8b737781cc
1886	12	2024-10-22 12:24:49.032402	f827c247-6ebb-40f0-b93d-8c3267dd97c6
1887	12	2024-10-22 12:24:50.881898	97fd0e0a-00c0-497f-870e-77e92825e352
1888	12	2024-10-22 12:43:27.62045	183a5a28-6337-4df4-8ca1-6183b707e3fe
1889	12	2024-10-22 12:43:30.898804	f0e94fbe-8413-429e-9a7c-4cb8ac474e09
1890	12	2024-10-22 12:43:32.840203	5b642673-0b29-41b9-9ffa-5e3a385ab5a9
1891	12	2024-10-22 12:43:36.492616	e2b258f7-77da-4c82-bc24-782df600fae3
1892	12	2024-10-22 12:43:37.626973	6e7452d0-3e78-445e-a353-a7039777d294
1893	12	2024-10-22 12:43:39.796092	76f1faee-f37a-4c9b-a928-69324f611aca
1894	12	2024-10-22 12:43:40.918232	6bcc12da-cb35-4373-98d0-b396ef27adaa
1895	12	2024-10-22 12:43:44.745223	7b24b006-34b1-4004-9c60-e8a89ba943d8
1896	12	2024-10-22 12:43:45.845305	c49792a0-61f1-4926-bcc8-84cee0d8c73e
1897	12	2024-10-22 12:43:48.33907	f84c065c-67c7-44e2-a8a1-1d2fd89f8a1a
1898	12	2024-10-22 12:43:49.45425	81dbd05f-436f-40f6-bc93-cd3b45903bf3
1899	12	2024-10-22 12:43:52.892365	313943f0-eed5-4f76-984d-6b73209dc937
1900	12	2024-10-22 12:43:53.997323	d2a11707-c971-43fa-9334-d2979d745cb4
1901	12	2024-10-22 12:43:57.467851	dd4f3482-4741-44c6-a299-1796dc7d5ee9
1902	12	2024-10-22 12:43:58.681638	a43c7c36-81e0-44f9-88eb-5b11566403ca
1903	12	2024-10-22 12:44:02.703696	8d4d9a71-b649-4127-ad16-4c0e85f93305
1904	12	2024-10-22 12:44:03.900948	3fcb3108-aaf3-45d5-96d7-d1841e70ed95
1905	12	2024-10-22 12:44:08.675891	36622c46-467a-4890-8d04-8f204a9cea3e
1906	12	2024-10-22 12:44:09.790236	22392335-8f82-4540-9b8a-c45a77d9a0ad
1907	12	2024-10-22 12:44:13.002202	8f9892fe-bede-4517-b9a8-ff27e5524fb6
1908	12	2024-10-22 12:44:15.005296	596d7273-9eb5-42e1-a6f2-a7f9babc3ee5
1909	12	2024-10-22 13:10:19.484969	c1551169-d3b9-41d3-8237-3c84c0d2179d
1910	12	2024-10-22 13:10:22.456488	f458c17c-dbf9-4e94-8c84-d218fe36039c
1911	12	2024-10-22 13:10:24.240472	a8862783-1d04-438f-aa41-0610d377579a
1912	12	2024-10-22 13:10:28.032699	2eeee5df-10ff-4d2b-9c46-6474f495bc2b
1913	12	2024-10-22 13:10:29.154023	b7aa1af8-a7ca-4946-b3a3-9159a8266c7c
1914	12	2024-10-22 13:10:31.403704	851d3b73-a107-4f1f-b384-bc0261b209a4
1915	12	2024-10-22 13:10:32.517163	e6aaa7f4-1dd8-4253-addd-4a002dff2184
1916	12	2024-10-22 13:10:36.35284	8a967f6a-3500-4d68-882a-658514c75ca5
1917	12	2024-10-22 13:10:37.530517	2dd98dc5-fe80-4aea-8415-2dabdbac2b6e
1918	12	2024-10-22 13:10:40.092536	30b464dc-e1db-40de-844c-3f5c52225a22
1919	12	2024-10-22 13:10:41.189342	ecb24f27-1973-43cc-9bde-9e7a89c88ed0
1920	12	2024-10-22 13:10:44.99726	ae37cd31-7add-475c-8899-0b9de6402ac1
1921	12	2024-10-22 13:10:46.16507	1e4b3d66-e667-4257-a28b-0f04b6c855fd
1922	12	2024-10-22 13:10:49.77923	704f478a-6fd9-4a8e-a0a5-756b002d5140
1923	12	2024-10-22 13:10:50.923578	1067cadf-bab0-4f67-8d46-05fe4481ebe6
1924	12	2024-10-22 13:10:54.920089	f493a6d2-1648-4f70-93d0-1c2b756173d5
1925	12	2024-10-22 13:10:56.184413	c6b05287-04c2-4ca7-a3f7-ce94f8676beb
1927	12	2024-10-22 13:11:02.342257	b878e4bf-0cae-4460-a888-5c95d00ba2c2
1926	12	2024-10-22 13:11:01.083296	a59cbd54-973e-49a1-88dd-bc0296e67db6
1928	12	2024-10-22 13:11:05.523924	e9772ecd-a88f-4004-a7e2-2b8a40378329
1929	12	2024-10-22 13:11:07.489707	276e883d-17a2-457d-80d9-b19a1a66788c
1930	12	2024-10-22 13:15:53.240422	c0e570db-44d6-427e-8f8a-562afc61fac9
1931	12	2024-10-22 13:15:57.027178	3c2251e1-f01e-4b8b-90e9-e28321c2fdbc
1932	12	2024-10-22 13:15:59.332458	de21315f-dd53-48b2-9aa7-e94dd1c80b45
1933	12	2024-10-22 13:16:04.924388	b8ac71c9-15a5-4bb6-b772-1e1904088dad
1934	12	2024-10-22 13:16:06.591386	ce3c21d3-386e-45f5-8ea1-1d11bea25dec
1935	12	2024-10-22 13:16:09.806163	fc27894a-da4b-46c5-a269-310d0dacf1d5
1936	12	2024-10-22 13:16:11.499124	aaf9fafd-0a9f-49ff-8e4c-04d9656dc045
1937	12	2024-10-22 13:16:17.256276	17fb0601-1880-4706-b175-d6650ca88ff7
1938	12	2024-10-22 13:16:18.898614	4035083e-829f-49ac-9d6e-8e6af07cdf13
1939	12	2024-10-22 13:16:22.618164	6b4be529-8dc1-47ed-9467-517086a93312
1940	12	2024-10-22 13:16:24.385121	a335e335-2f40-4259-9d0b-c3d1ce027216
1941	12	2024-10-22 13:16:29.628263	6dc86c7b-12c4-476c-b20d-1cfb7fb49cd7
1942	12	2024-10-22 13:16:31.236453	3e80ebba-a7a8-4422-9ab9-69d83d29889f
1943	12	2024-10-22 13:16:36.344579	3eed4490-1ea5-4273-9a41-83fcdb2f1be6
1944	12	2024-10-22 13:16:37.977609	1c0d8ed3-fea4-40eb-b96c-91526d366e23
1945	12	2024-10-22 13:16:43.533755	d964cea2-6060-4edf-bae1-12938995e157
1946	12	2024-10-22 13:16:45.167509	0c7e34cc-d333-4dfa-a994-12acdd74b413
1947	12	2024-10-22 13:16:52.362433	f76e8f60-dc6b-4f6d-83c5-06bae3f08c97
1948	12	2024-10-22 13:16:54.016321	bb706f61-9cfd-4176-a069-bc018a7be2a4
1949	12	2024-10-22 13:16:58.582354	905f180f-2c1f-4467-a8e2-bf4d9f69fb0f
1950	12	2024-10-22 13:17:01.476062	b2070a78-0c9f-4200-afb0-96d2f5852ec0
1951	12	2024-10-22 13:18:14.620109	faf6ff05-01b5-44e5-aa45-8c129af4d547
1952	12	2024-10-22 13:18:17.881354	87c5c7cf-4766-4328-bba2-22419f4f5bde
1953	12	2024-10-22 13:18:19.798429	aea86ecf-ad86-49b8-b4b0-ae9498bdb068
1954	12	2024-10-22 13:18:23.920794	295c34a2-4281-47f2-ba47-086f0ae0b640
1955	12	2024-10-22 13:18:25.167556	a21e9cd9-f713-4774-8f96-1324f951d0b4
1956	12	2024-10-22 13:18:27.777908	5c17456c-a082-407a-95a0-ef91b76ea902
1957	12	2024-10-22 13:18:29.040762	6fdb2e91-4db7-4f0f-871d-ad9298d21f0c
1958	12	2024-10-22 13:18:33.377778	2d5c659b-4e7d-4f50-8246-74447a75fa08
1959	12	2024-10-22 13:18:34.608889	58c74b61-733d-4eed-84b5-fe61276d25a2
1960	12	2024-10-22 13:18:37.386126	b0967a9f-d863-4bf5-a574-ff372c7bd90f
1961	12	2024-10-22 13:18:38.6181	c72b7d1e-7b14-4a0b-874c-2df721599f53
1962	12	2024-10-22 13:18:42.487847	90c90264-9b3e-4f6b-b18f-4a9ccf7835f5
1963	12	2024-10-22 13:18:43.735923	b8af2da8-4340-47b7-b2d8-7a549335e0bf
1964	12	2024-10-22 13:18:47.607876	b7e8e787-e5fc-4e0d-bcdd-26d30d3676e1
1965	12	2024-10-22 13:18:48.82878	da2648a1-eb7d-42ec-b824-feac8d51f2c0
1966	12	2024-10-22 13:18:52.91992	c7692c2f-e837-4c60-bd71-9598fee8d113
1967	12	2024-10-22 13:18:54.163934	b42147f4-bbf4-46ec-9516-baf582898d50
1968	12	2024-10-22 13:18:59.381846	65f08e2e-6ce7-4212-91f5-38b95f572753
1969	12	2024-10-22 13:19:00.637648	f9ba6ec3-4ad5-4cb6-8909-703df481ff81
1970	12	2024-10-22 13:19:04.071256	6b25d41e-6386-4ca0-bcb2-2db021ecdc2c
1971	12	2024-10-22 13:19:06.179901	9a847f27-9ea5-47c6-b44f-ca8d8483ce50
1972	12	2024-10-22 13:22:35.667055	080df258-e54d-4f2a-a714-929be31d44fd
1973	12	2024-10-22 13:22:39.420788	8ea680e7-0187-4229-b7cc-64e0dd1c9980
1974	12	2024-10-22 13:22:41.775282	86a80757-c8bb-4ea8-bb41-bb041996d0e2
1975	12	2024-10-22 13:22:47.163962	f3d48957-9a5b-406f-9cf6-fa96c4040788
1976	12	2024-10-22 13:22:48.827858	59ffd6d6-113d-45f4-8276-09abe0813cab
1977	12	2024-10-22 13:22:51.970217	e132cdc6-6f84-4739-a8d3-3c554dba1914
1978	12	2024-10-22 13:22:53.618984	84cdb108-5e52-4d02-b79d-f1748e3c5974
1979	12	2024-10-22 13:22:59.359751	c8e9e929-298d-4ace-b3a4-c3b8380e2328
1980	12	2024-10-22 13:23:01.064931	0f6c64bd-1feb-4834-b872-f7728be79ba3
1981	12	2024-10-22 13:23:04.841961	f21671f8-5d28-4e74-9d5c-68288f5ffe3a
1982	12	2024-10-22 13:23:06.482431	2518e568-1555-475c-8d84-b28a7104772d
1983	12	2024-10-22 13:23:11.646435	f9b3b560-8cef-46c6-8496-48c99f54764e
1984	12	2024-10-22 13:23:13.403872	7cb11c62-c91e-4422-857d-96290dafb934
1985	12	2024-10-22 13:23:18.668336	a88ae9f6-55c4-496c-b7e5-8d9add2c4d9b
1986	12	2024-10-22 13:23:20.33454	b8194ede-83ce-4977-b0ac-7197a19ed6c3
1987	12	2024-10-22 13:23:25.907542	2893a86e-5cdb-42ed-ba17-3933ebbedb77
1988	12	2024-10-22 13:23:27.527704	77129bcc-12e8-49a1-ad37-55ffef56ccc5
1989	12	2024-10-22 13:23:34.679783	de1c70ad-cd95-463c-9bbe-3f3ad46fd6d7
1990	12	2024-10-22 13:23:36.30593	90591503-dddd-4809-89d0-2f83d9a78fe6
1991	12	2024-10-22 13:23:40.90894	930b19e8-4393-4b68-ad3b-5ca8d678964b
1992	12	2024-10-22 13:23:43.841877	1f7e4548-6a3d-456b-b4cb-f43b59d0b36e
1993	12	2024-10-22 18:34:56.666594	2fb430e6-b022-41f8-a841-1fe9dd683c63
1994	12	2024-10-22 18:34:59.947442	d99bfb2f-bd45-4bbb-9c5c-9334f853e0df
1995	12	2024-10-22 18:35:02.093065	4551a182-adca-4e1a-a872-69f8c38764fb
1996	12	2024-10-22 18:35:06.100594	624c5a98-d868-4a8d-8b75-2e8c70a6e135
1997	12	2024-10-22 18:35:07.310053	594c52db-bcc1-4524-9c3d-bbd569447888
1998	12	2024-10-22 18:35:09.664595	b2f6a847-309d-4f02-b83a-d165be4934b7
1999	12	2024-10-22 18:35:10.912404	15aad998-6b5c-48bb-aeac-80fe6a13432b
2000	12	2024-10-22 18:35:14.863659	dbb6a57e-fcd4-4985-8cb1-33abbf60892f
2001	12	2024-10-22 18:35:16.003121	4ed17f3b-3eff-4a6e-b154-bef11fe04e2a
2002	12	2024-10-22 18:35:18.52837	52a84e4a-b2f6-4407-8cb7-0b42df5cc651
2003	12	2024-10-22 18:35:19.688192	77bf38bc-f415-42d7-9adf-0386870f843e
2004	12	2024-10-22 18:35:23.168488	a9973ffe-8992-4c89-9984-e30b39c08719
2005	12	2024-10-22 18:35:24.285732	663f3cc1-366f-42cc-9a77-ec623fb8a761
2006	12	2024-10-22 18:35:27.826328	430da926-b127-4027-9e2f-79d94aaa0e3d
2007	12	2024-10-22 18:35:28.937233	740e6fd8-a270-4bde-ad23-e031e406f492
2008	12	2024-10-22 18:35:32.850736	ae50148b-6746-4f57-adba-04e9dc7d0340
2009	12	2024-10-22 18:35:33.984105	9395dc76-0d42-4eb2-b390-eedb6dee1e67
2010	12	2024-10-22 18:35:38.670115	87c9b9af-36f7-4477-a231-43814eadf5b0
2011	12	2024-10-22 18:35:39.802325	e62538fa-adc3-46d1-a7fc-dcb9deab323c
2012	12	2024-10-22 18:35:42.803165	34084f20-08e0-44c8-90bf-6df51007babf
2013	12	2024-10-22 18:35:44.723261	25395c0b-d3db-4d2f-9bac-8ca266e2fd55
2014	12	2024-10-22 18:36:51.961252	e516ade7-e9dd-4c01-8181-dada25698013
2015	12	2024-10-22 18:36:55.6538	24fd4dc8-0f84-437e-b77a-dfcf91f0870c
2016	12	2024-10-22 18:36:58.001188	6b2bb692-24ec-4ec7-9fa1-d39d3e202cd0
2017	12	2024-10-22 18:37:03.593887	f1754e08-907f-4621-802d-93989055c1e8
2018	12	2024-10-22 18:37:05.359734	e118e98a-6779-472d-a1c3-43a441c77820
2019	12	2024-10-22 18:37:08.748211	52a45b99-2f10-452c-8940-899bcb1d28d3
2020	12	2024-10-22 18:37:10.430476	cc37cfcd-e44c-464c-a78d-e83422ef7e01
2021	12	2024-10-22 18:37:16.289685	0d96a2dc-b3a0-4e3c-b2d6-4b188ade4f55
2022	12	2024-10-22 18:37:18.005343	45fd43b4-50eb-4aab-a5d9-49085d34e993
2023	12	2024-10-22 18:37:21.793011	b72e4989-228b-4f02-96b1-a3694ae33648
2024	12	2024-10-22 18:37:23.545651	e090290a-7ed1-4de0-b694-c1f508f30167
2025	12	2024-10-22 18:37:28.870738	bdd686d8-7830-48af-b189-4923b8b60f24
2026	12	2024-10-22 18:37:30.706317	895f57e8-231d-4eb0-a6ae-d1452b7750cc
2027	12	2024-10-22 18:37:35.891106	4ebc87b7-b236-4e19-aa70-f826da0623a4
2028	12	2024-10-22 18:37:37.544625	4cd60a23-b389-4978-b109-fb067ff3d0f8
2029	12	2024-10-22 18:37:43.139306	1948018e-0e16-40f7-b0a0-800c80bbab51
2030	12	2024-10-22 18:37:44.788739	b9cb2b57-ed69-4146-949e-78bdab9a2e97
2031	12	2024-10-22 18:37:51.923647	fdbad2d9-920b-4174-8a27-a5a1f7dcdaa2
2032	12	2024-10-22 18:37:53.556441	1382f146-4159-4448-9c41-21280c321df1
2033	12	2024-10-22 18:37:58.178874	5f8f5820-2055-4049-8947-07b18c6d3695
2034	12	2024-10-22 18:38:01.086614	8b671538-8db6-44d7-9688-439104c7fc73
2035	12	2024-10-22 18:38:35.493849	78106d02-1d3c-47e8-b6b0-be06ef721c67
2036	12	2024-10-22 18:38:38.330538	145e2fc0-2fbd-43ce-b472-492dd8160770
2037	12	2024-10-22 18:38:40.274281	ecc09b8d-8da5-4671-977e-0a0c41018376
2039	12	2024-10-22 18:38:44.927049	642c597b-18dc-429b-b57d-52ab156fa460
2038	12	2024-10-22 18:38:43.820208	ff6b9d6c-b2ec-4613-92bf-fb4548577700
2040	12	2024-10-22 18:38:47.226949	15971ed0-d673-4c1e-a563-655b67fa5a02
2041	12	2024-10-22 18:38:48.488378	bd2b3ae2-30bf-454c-a94c-442a1a594659
2042	12	2024-10-22 18:38:52.305849	af7ab4c7-400d-4f3e-baee-3e065ca58377
2043	12	2024-10-22 18:38:53.402845	993d1841-665f-464e-a882-34b55c7fbc58
2044	12	2024-10-22 18:38:55.896334	aa0d1497-58b1-43b2-be2b-cbb7f7d2cd33
2045	12	2024-10-22 18:38:57.020394	c31efdbb-440f-4db7-97d5-4832ee58fa90
2046	12	2024-10-22 18:39:00.536598	3e735287-8d4f-4fdb-9f96-4f0ab6ebe4f9
2047	12	2024-10-22 18:39:01.780036	dbf3d850-f675-47af-8de3-0f392a34fb14
2048	12	2024-10-22 18:39:05.443905	70bba41d-666c-4c96-a732-8c86fcddfde0
2049	12	2024-10-22 18:39:06.59897	2183b230-a811-44a9-8885-d026c515b586
2050	12	2024-10-22 18:39:10.238304	7812fdd1-9589-4f7e-81a3-e4158fd0f9aa
2051	12	2024-10-22 18:39:11.309391	22aff4dc-f273-4138-938b-6a32a7464b2e
2052	12	2024-10-22 18:39:15.930398	42f5933d-e816-4f9f-a303-7b50c59f3647
2053	12	2024-10-22 18:39:17.002266	7f91b8ba-b2ae-4c60-bb53-81bd80d138b6
2054	12	2024-10-22 18:39:19.956556	b5ae36df-00c5-499f-b27d-d0c55a35d0b0
2055	12	2024-10-22 18:39:21.841271	a2cd3911-9711-447f-9a03-46c07ba71034
2056	12	2024-10-27 12:06:21.427822	958d72f5-de97-4aea-94a6-faceccc420e3
2057	12	2024-10-27 12:06:25.219896	e64ba810-6dfa-45c6-bd46-ad833a40dafa
2058	12	2024-10-27 12:06:28.04275	69bb8a5c-b58f-4031-ac39-83f3d7bd8c87
2059	12	2024-10-27 12:06:33.567535	36908308-f191-48d3-b5a9-3a130cf8a3ac
2060	12	2024-10-27 12:06:35.217145	8798d464-8800-4720-afea-b901d64e1578
2061	12	2024-10-27 12:06:38.394056	d91f3cb8-2bbb-4bcd-b474-e0bc975f4957
2062	12	2024-10-27 12:06:40.028892	173ec7fe-febf-4db6-a3d0-63fc080d9d4c
2063	12	2024-10-27 12:06:45.647304	dd2516d1-a25f-43c2-943a-83a0d5ea8139
2064	12	2024-10-27 12:06:47.265967	b66e8114-1039-44e7-afb9-ba68630dba5d
2065	12	2024-10-27 12:06:50.847368	aebd9bb8-2c28-4911-9344-333d123761a6
2066	12	2024-10-27 12:06:52.552902	e775d8bd-1a50-43d7-a561-01082ef4881a
2067	12	2024-10-27 12:06:57.564158	2e7bd39c-600d-4d2f-bc0d-53a784ac4b5f
2068	12	2024-10-27 12:06:59.199053	580b21e1-5222-4ef9-a28b-681ddc204209
2069	12	2024-10-27 12:07:04.356808	e53ac01b-b5eb-44c4-90f5-60d4ccaf6be5
2070	12	2024-10-27 12:07:05.990137	51b1b6ea-87a4-4a9a-a3a9-b29e2f931c9f
2071	12	2024-10-27 12:07:11.41066	c783cb64-485a-4e82-a3c3-e4074aef1983
2072	12	2024-10-27 12:07:13.07165	01976aff-1fd2-40ba-ad75-719d78d31373
2073	12	2024-10-27 12:07:20.146474	3f5e28b2-9f51-4897-a760-89a4117fe46d
2074	12	2024-10-27 12:07:21.775294	e34f1b94-3d5a-4599-a410-71b7c9f4b959
2075	12	2024-10-27 12:07:26.466403	6a10aa53-361b-49a6-b637-859bed3c3e59
2076	12	2024-10-27 12:07:29.240977	9a3eec98-6331-49a9-8fac-c95313908313
2077	12	2024-10-27 12:21:36.299976	c8a06e88-708b-4c6b-afb9-b50366beb291
2078	12	2024-10-27 12:21:39.42623	d5b5befa-0a03-4f1c-b5b1-78addc7e3b85
2079	12	2024-10-27 12:21:41.23782	d54d7b36-3cf0-40d1-9ba5-ab4194e73fc9
2080	12	2024-10-27 12:21:45.211858	8ae6a849-0757-4d28-96a2-0a189f1052a1
2081	12	2024-10-27 12:21:46.487197	8eb590dc-2d28-4a08-8920-cd101bd446bf
2082	12	2024-10-27 12:21:48.817462	76329c7f-262b-40fe-b54e-182fda99b40d
2083	12	2024-10-27 12:21:50.059072	90fa30cf-51d3-4763-af0e-9f7cf7c01f7e
2084	12	2024-10-27 12:21:54.273875	31294030-c5d5-4d43-ba1f-09b6e260af85
2085	12	2024-10-27 12:21:55.50755	c07b4ca1-f8df-4b44-aeef-1f2808ff3a4a
2086	12	2024-10-27 12:21:58.197866	fbbd2232-84ec-4bfc-b188-093ec4b42f8b
2087	12	2024-10-27 12:21:59.39644	2fa7fe2a-6ea2-4730-ad59-23841c283506
2088	12	2024-10-27 12:22:03.221213	186ee9d5-dd5d-44ee-93da-153db84cc8c9
2089	12	2024-10-27 12:22:04.43474	ca759caf-112e-4185-baae-a090c2572828
2090	12	2024-10-27 12:22:08.284719	a49c7b65-44a6-436b-a0cf-a1721cffa5c5
2091	12	2024-10-27 12:22:09.484702	c7d7bab8-8fd6-4de1-a944-88152e783acb
2092	12	2024-10-27 12:22:13.519574	5b4930e5-dd4c-41ae-b16c-0aa3a1c18f9b
2093	12	2024-10-27 12:22:14.75794	fe93364f-f581-4b93-a799-552b373ec4cf
2094	12	2024-10-27 12:22:19.918645	c931bc55-df87-43ee-9d5b-198e6e3ea257
2095	12	2024-10-27 12:22:21.114396	bfbbd9d4-3c9c-4fb5-9b33-9eb405c2c8a6
2096	12	2024-10-27 12:22:24.393466	4baa1473-91c2-458f-a926-ee22e7bb405e
2097	12	2024-10-27 12:22:26.424877	45a12014-21a9-4477-81fb-6765c9ef4074
2099	42	\N	788b6406-d093-4774-a001-364436a29685
2100	43	\N	9268c82c-1590-4a06-9188-c1c8d982aaf4
2101	44	\N	9ff1675a-8cab-4c7c-af80-88fc23c9cedf
2102	45	\N	10bac07c-6468-4ac4-8829-567fbfed21fa
2103	46	\N	9d97862a-814b-4141-86d7-fb47298ed0c0
2104	47	\N	4485286d-026e-4c46-8b36-d12e07886308
2105	48	\N	5b750fa2-36d9-4b9e-b3c6-4dbe21d3ff6a
2106	49	\N	39b62001-cfa8-4a6d-aa9b-1023990836dc
2107	50	\N	198b9be5-81eb-4369-a377-3653ffc8625c
2108	51	\N	4d448846-3e69-4a79-85bf-34c83177bc91
2098	12	2024-10-29 12:09:39.188211	ba3e2b73-1587-4b4a-8fc4-7068d60b81ec
2109	12	2024-10-29 12:09:42.970722	8f06219b-0b90-4184-a6ac-ce43f76434ed
2110	12	2024-10-29 12:09:45.360782	a1ec66fb-a15d-48db-a2d6-73b796203ff4
2111	12	2024-10-29 12:09:50.667408	88565e0e-0fe6-4ea8-8311-e9b161908a6f
2112	12	2024-10-29 12:09:52.31132	2694f02c-4fcb-423a-af3c-9d7486910831
2113	12	2024-10-29 12:09:55.511552	830d753e-ecd5-47dc-97aa-a8c75697f196
2114	12	2024-10-29 12:09:57.20167	d5065922-f530-415a-85e2-3db155c2e413
2115	12	2024-10-29 12:10:03.499754	03ff5db7-e71e-432f-b438-5c2250492ece
2116	12	2024-10-29 12:10:05.343174	b74da66d-af25-4542-8eae-1ad9fc8f9166
2117	12	2024-10-29 12:10:09.155164	d49c60cb-73d1-4b3e-8c02-608800e88770
2118	12	2024-10-29 12:10:10.83443	1a73c8e6-27dd-40f5-9516-4da332aa1ba7
2119	12	2024-10-29 12:10:16.112942	c6b6e833-1e40-41fd-9664-8bbcef6fd6ba
2120	12	2024-10-29 12:10:17.77399	80d36313-150a-49ba-a2e2-15a81ecb1564
2121	12	2024-10-29 12:10:22.970181	1fe07895-ece7-4cd1-8ffe-54cc572711db
2122	12	2024-10-29 12:10:24.629922	26fe6d8f-0d34-4273-9ad3-88da6b07cd82
2123	12	2024-10-29 12:10:30.244535	455ae50c-6a49-4142-bb86-6d4a043b0b83
2124	12	2024-10-29 12:10:31.896215	89498d71-f343-4167-8c04-e6973993c611
2125	12	2024-10-29 12:10:38.991502	24361577-8fee-4da9-bcfc-008f09683340
2126	12	2024-10-29 12:10:40.695659	305563d8-8885-4dc9-b031-b2f3210d3f81
2127	12	2024-10-29 12:10:45.25582	89651e09-79f8-4116-a020-49bf32315072
2128	12	2024-10-29 12:10:48.106785	e1c7aaff-d78a-4102-b3e5-1db7a7f174ad
2129	12	2024-10-30 18:22:13.551407	0123c7c4-aacd-48ce-8e2c-a065cc068aa8
2130	12	2024-10-30 18:22:16.489758	df163e47-ad6e-44e6-ae02-de5f47579270
2131	12	2024-10-30 18:22:18.315248	4a72ca12-d3ae-4597-89da-c4ccb3d6607f
2132	12	2024-10-30 18:22:21.934361	300b6b99-71f8-4aff-9501-6c8cc062e772
2133	12	2024-10-30 18:22:23.063694	de48a7d4-a5ca-4898-bd1f-50aa604ebb58
2134	12	2024-10-30 18:22:25.230505	0a747f08-6ff9-4919-a713-8f65e4865a58
2135	12	2024-10-30 18:22:26.414899	e5cbc3e1-2c4b-40ab-ab66-6e48de0efb36
2136	12	2024-10-30 18:22:30.211309	a46f9c71-367d-4138-9322-f7dd04ddc298
2137	12	2024-10-30 18:22:31.305458	04077133-0c7b-46cc-8c1f-b9db7f7d1e2a
2138	12	2024-10-30 18:22:33.747726	b54ea13a-9904-4e6d-8479-71cde51d5225
2139	12	2024-10-30 18:22:34.821604	e0bab6c6-5c79-413d-b5aa-ae56ea12ebf5
2140	12	2024-10-30 18:22:38.184542	9aa73f52-191b-4480-ad34-f17e439b8cc4
2141	12	2024-10-30 18:22:39.248497	da9d74f4-52f6-43eb-9732-ab8f896868ff
2142	12	2024-10-30 18:22:42.66146	80996021-5666-4d21-8c1c-ecf78c3a7c1a
2143	12	2024-10-30 18:22:43.70606	2779133f-326b-4593-9b49-0a39a47e9e1c
2144	12	2024-10-30 18:22:47.222606	5bc79961-b13d-424e-b9b2-18121bfe9efb
2145	12	2024-10-30 18:22:48.276707	19330837-2489-49f8-b737-e3a72684868b
2146	12	2024-10-30 18:22:52.759684	f1cf93c1-3f06-4e56-b1d0-95bc8ad669a6
2147	12	2024-10-30 18:22:53.840383	fe8d3046-eaaf-4793-894d-c9f6ad32247a
2148	12	2024-10-30 18:22:56.762106	2985ba40-e6c0-4841-9595-6856e7110eb7
2150	12	\N	9f825cf6-8ed5-4e54-b0fe-06a543350749
2149	12	2024-10-30 18:22:58.540526	9ea5c81a-971c-43f8-91bd-7e841db69cb9
\.


--
-- Data for Name: t_user; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_user (id, username, password, client_id, uuid, role, created_at, device_token, email) FROM stdin;
14	newUser	$2a$10$yuPGs2dFcjcB4MzUHNz3SOwdkPPU9svMLMpuebhAA99tRBrNfjGhK	1	d0a90bae-8cbf-4693-818e-6146fde912a0	WAITER	2024-10-21 13:17:47.201472	\N	newUser
15	newUser3	$2a$10$v3xk0Uq6OI8fX6qtZXrTyeDZUZbVFVs/IIVOiqkUnI3vnZUT1HweW	1	755aa79c-8995-4d98-8a7f-7f74d6899152	WAITER	2024-10-21 13:19:01.365547	\N	newUser3@email.com
16	newUser4	$2a$10$/fESpYtl8IiI8G6duevhXunZKtwizb1Ph5Mjy/p520QmN3HpUcmi2	1	55802701-0e84-40e0-9d97-35976a1917cd	WAITER	2024-10-21 13:20:24.313317	\N	newUser4@email.com
8	vadim	$2a$10$7u3xIKRYUWvCIPedVosbnepXbR1KwsOxi9v.f3QbD1r66xnBHCTWi	1	6dd7f086-b05f-4038-8c6d-d1d094fdc5ac	WAITER	2024-01-09 14:54:20.965021	\N	vadim@changeme.com
13	user_e2e_api	$2a$10$evY17gNycDR7xdYUKpRHJ.tMxM41gV8kHE1KfSrrMHcMxEIlre1Rq	2	2d97da84-b24c-4066-b20c-c69b8d7b46a9	WAITER	2024-04-02 15:13:05.687215	\N	user_e2e_api@changeme.com
4	dima2	$2a$10$PiK2hmZq2mewBQE4VozP9eVlQX2u7AyVqwnFqMI24OFQRvpLPUMHe	1	dbe79938-304f-4791-b607-ffdb863a4d7c	WAITER	2023-11-28 11:22:29.750021	c3wa-TaPTCqYqnDaM8Xl9B:APA91bHuxYpzzkBR90OgngIpml18JgTBvV2Wwc71wQ_DPdr_Ryp4ZC1xqbnH8Dcjy8DoYjC_kuksRPT9cfiTkRXHngJGauhs0hcD0xDpsLXfsG28D6f4A_L4KxZMMmUnw9nBbIdr39H1	dima2@changeme.com
3	dima	$2a$10$rZ2SbaoeaoHbWIWucJMsqOMfyJPjre7bYatr0MDSN7t6i5qlYILLy	1	f8dfa29e-d830-4680-9fb5-75baf0a1ddd6	WAITER	2023-11-19 17:10:29.698281		dima@changeme.com
17	newUser6	$2a$10$arlOpGQo5OkLri7AXHmKLudacAOsTh3LFCRzDDsm2B4hqRK8V7fwa	1	3ce10a5d-7677-4acd-930c-b4b79e0519de	WAITER	2024-10-21 13:27:46.560492	\N	newUser6@email.com
1	test_username	$2a$10$kYrMbFSA8n7hnNVcWfTLpOJC.BIIuOpAYWJOzL7rNB25uuSGmx0sC	1	b1728e12-d9bf-4f03-991e-7e915e1d5fc9	ADMIN	2023-11-04 13:52:12.695194	dxyhkwDrV0P4sVUvadh4x_:APA91bHfLHO0ZjAZ7D5mXf2VN8eD5QGSwgGXJyry_ijVh4TZSg3Frv2ogwHu465xR5ocz2-XjvO5r5bzWzibcAorCU_5FFQDg-P0_-F_u5OWM_ocJ4ESrmLX84LaEwjJbeT2mRIZpgvK	test_username@changeme.com
6	appstoreconnectreview	$2a$10$bUFsrAGPsEkU07wEoNL/MuIBx9ssjvtRgAhZxk2Sq4aYHUH.Vnb.C	1	50a34459-6a95-4f83-bf5d-cacdfa9506a6	WAITER	2023-12-25 12:32:35.620819	c7mgdi9G1kqFvjYIHgZi9a:APA91bGLf7f9v_8iRBY5e39WeXNnB3ZoR_CYB-F4hxZa5OI-wAOTWA6jn7jDsb0mpcDI1vPtpd35gsHRJJJ_8JlpcD2QdNgSsg0SVOf6zeZTAMRD2EkPJ6lJdpQj50SGHEPv8GjZ_GS3	appstoreconnectreview@changeme.com
7	dani	$2a$10$pMRM4FAVNSpy1vV4i0dQ7OsuFq/A6Nmx0S9tAOrdr76MldhMICVUy	1	ad7afd12-e58e-4b42-9531-a5c2a5bf5c95	WAITER	2023-12-26 13:29:04.785122	f7NrJ1LsmkrYqoFopgDTJU:APA91bELoZOqXKgXXWobolUPeljwXNkuHyh_6HG1NLMDM_688J2V3fMB0BVaGFKw_SEIXcMl0o-LH9U7GkzEhNDylFmJoFXtD4_d88YG0IfAKSN-Wkns_gayKxbW6zf1etWbNhYreog0	dani@changeme.com
12	WaiterSteve	$2a$10$PSo87qRPLTDd.JumKgieW.mMt5rxrrOx.57nnmQ5So/qU.4ZoDFY2	3	7e2625f7-e8b1-4ade-be5e-260fca713d8b	WAITER	2024-03-02 18:58:42.987729	enlv5tYgWUKzvC7cZPqWIn:APA91bEH7EF5RE_qhZrqPOnRCiXdMA2FbE1bJwei5x3fgZxOusR_LvttZVs1tZoAn-cx_6NVbJVABUlhm-JTMuiEN3J1xzQBgCV6hrIvvzNnP7f1klnwGH8msrGciUpCNpScY1gbozxE	WaiterSteve@changeme.com
48	newUser98	$2a$10$QFovtUxerTRfqPVWEdOmvOyzba4k4/sSpzBc0Pt5TirXRObKi/3eW	1	ea123b99-532c-4511-a7be-837e65112cf6	WAITER	2024-10-22 12:20:59.599305	\N	newUser98@mail.com
51	alex	$2a$10$n1k.CgtGMXJpBBoDsJfc0.60ipBAepzQn2SjZ7eBXmgPoMjkbnDtK	4	7bbd38df-1825-4f03-971b-49899bb1bcab	ADMIN	2024-10-27 11:40:15.733344	\N	alexandr.ter98@gmail.com
49	newUser7	$2a$10$.naWdCIEoha6Vt6oJOjVJ..xE2Z4TzhitbEsCL26z8FQdCuP47eMa	1	009f2038-c4f0-407c-8e41-aca291f0debf	WAITER	2024-10-22 13:21:04.75053	\N	newUser7
50	newUser8	$2a$10$rFTs5kAKpfHnRpxJ.sIUeuHE5A7flbRQyzQL9H2DZSehgLIbiFj2m	1	e6fd1304-bbda-4b12-970f-cb721ca5573c	WAITER	2024-10-22 13:22:58.893121	\N	newUser8@asd.asd
2	alex_support	$2a$10$33q0QAnT4w0YZQGoLxCNHO673860bmVIGA17ptqAoiXwm7Mwa76hq	1	0036cb14-3a84-47fe-a7b7-033dc295a9a2	SUPPORT	2023-11-19 17:10:21.229281		alex@changeme.com
52	dfasrqe	$2a$10$F1PLuJLjxiQKv1f5Ld5y1.pHog7rZUg5wWhZZutT1FXZUEaSlifjy	1	484a7700-fb13-4665-ab58-0665eeb9829c	WAITER	2024-10-28 21:05:06.089603	\N	rewrew@gmail.com
47	newUser97	$2a$10$UoghHrRsytKnDwth64Kt4OFngXVNnQe56TuBn9M3t17hqHfOoUMie	1	dc014abc-65df-4cfd-b5e9-bfe0cd35aaf4	WAITER	2024-10-22 12:18:12.630379	\N	lemon.vadim@gmail.com
5	alex4	$2a$10$fFXSsJ2hLiuS3HhZr41BmOypGSWby/uPOqMsYW/l/50NyG9rt3CPS	1	b851b58f-1a3e-4581-a033-5851195883a0	WAITER	2023-11-30 14:39:54.105357	eJPy1ustxUoblbCCIBzeDI:APA91bGJzjQ8p352bdLb2L0hxa0hq53aVvfNOHxNLLXlh0bgDqsPuson1_-8QMV2YUf-qwIkF0BXb1OXypRyJV3JZNFcMxiIEGDSDgEMqcOEKw9JcHNLNeDotFaIGQ0DOq-ph7KMq1Kt	alex2@changeme.com
53	iana	$2a$10$.fnuF/N.CpOclAB2bWdQye29i4C7YjCp7keMvFXKrFfz/f1O4kBcO	4	4aeae8e1-efa5-4b80-a2ce-6f4b14b22af3	ADMIN	2024-11-20 17:10:08.894735	\N	Yanasergheevna6666@gmail.com
11	WaiterJohn	$2a$10$n4PVuwZTDhGy6Hob9uxpq.81.ppFTeyEjo6Rhs9OiZChcz8SjmkAO	3	6c0876fe-efda-45a9-962c-45ba63216dca	WAITER	2024-03-02 18:58:29.475531	eO74-K3lTB-EFi90vmL5iH:APA91bE5d1jxuNOeFKF7lK9PWGMidcKcgSEVbh5UavDiixrgzgdkIm6KZjr77Mo2plR2bL3b9kAqNjl3vju_8gTYHG3OpmmsLDzljwglFTsHThD9CGHXmJg	WaiterJohn@changeme.com
\.


--
-- Data for Name: t_user_branch; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_user_branch (user_id, branch_id) FROM stdin;
8	1
13	2
11	3
4	1
3	1
12	3
6	1
7	1
2	1
1	1
14	4
14	5
15	4
16	4
17	4
48	4
48	5
49	4
49	5
50	4
50	5
52	1
5	1
5	5
47	1
47	5
53	6
\.


--
-- Data for Name: t_user_table; Type: TABLE DATA; Schema: public; Owner: doadmin
--

COPY public.t_user_table (id, user_id, table_id, started_watching_at, stopped_watching_at) FROM stdin;
113	13	12	2024-04-05 11:24:26.756043	2024-04-05 11:24:34.068989
1	1	2	2023-11-04 14:25:47.617811	2023-11-04 14:26:26.416646
114	13	12	2024-04-05 11:24:36.439656	2024-04-05 11:24:40.688637
58	12	36	2024-03-14 13:21:20.305504	2024-07-08 12:06:38.939214
5	1	1	2023-11-19 19:40:30.36729	\N
115	13	12	2024-04-05 11:24:43.298101	2024-04-05 11:24:49.328604
6	1	3	2023-11-19 19:45:13.313132	2023-11-19 19:45:14.329602
7	1	3	2023-11-19 19:45:14.9528	2023-11-19 19:45:15.486934
8	1	3	2023-11-19 19:45:24.592637	\N
116	13	12	2024-04-05 11:24:50.24404	2024-04-05 11:24:58.443788
9	2	2	2023-11-19 21:08:25.269954	2023-11-19 21:08:27.147438
11	2	4	2023-11-28 11:12:43.329207	\N
4	2	3	2023-11-19 18:20:10.137045	2023-11-28 11:12:46.912604
118	12	31	2024-04-05 17:36:36.104013	\N
3	2	1	2023-11-19 18:20:07.556662	2023-11-28 11:20:34.952043
117	13	12	2024-04-05 11:24:59.284523	2024-04-07 05:01:18.127098
15	1	9	2023-11-29 14:32:22.844332	\N
13	2	1	2023-11-28 11:20:35.612324	2023-11-30 14:41:39.825169
16	2	1	2023-11-30 14:41:40.533286	\N
12	2	3	2023-11-28 11:12:50.114896	2023-11-30 14:41:44.347744
14	2	6	2023-11-28 11:20:38.162755	2023-11-30 14:41:49.033607
17	5	3	2023-11-30 14:43:29.98067	\N
18	5	5	2023-11-30 14:43:32.991722	\N
119	13	12	2024-04-07 05:01:19.038	2024-04-07 05:03:14.891546
120	13	12	2024-04-07 05:03:15.838473	2024-04-07 05:08:40.926251
22	5	2	2023-11-30 18:53:08.820056	\N
23	1	4	2023-12-01 08:51:03.735733	2023-12-01 08:51:04.912987
24	1	6	2023-12-01 08:51:12.61235	2023-12-01 08:51:14.024576
25	1	6	2023-12-01 08:51:15.734894	2023-12-01 08:51:16.466765
26	3	2	2023-12-05 20:07:42.613653	\N
27	3	3	2023-12-05 20:08:04.866097	\N
10	2	2	2023-11-19 21:21:56.086451	2023-12-05 21:06:31.079276
28	4	2	2023-12-06 17:49:04.522617	2023-12-06 17:51:45.704437
29	4	2	2023-12-06 17:52:40.487425	\N
30	4	3	2023-12-06 17:57:21.904333	\N
32	4	4	2023-12-06 18:10:46.289774	\N
33	4	1	2023-12-06 18:18:47.635367	2023-12-06 18:18:49.107073
34	3	1	2023-12-09 18:36:39.265504	\N
35	5	4	2023-12-12 17:02:14.29461	\N
20	2	3	2023-11-30 17:32:30.699406	2023-12-12 19:07:56.057508
36	2	3	2023-12-12 19:08:00.087907	\N
21	2	7	2023-11-30 17:40:34.003382	2023-12-12 19:08:04.213165
37	2	2	2023-12-12 19:10:37.553514	\N
38	5	1	2023-12-12 20:09:30.351973	\N
39	3	9	2023-12-19 22:44:07.606381	\N
31	3	4	2023-12-06 18:10:43.848667	2023-12-20 07:48:50.934666
40	3	4	2023-12-20 07:48:51.636594	\N
41	1	4	2023-12-22 02:10:55.533007	\N
42	2	5	2023-12-25 10:22:53.528844	2023-12-25 10:23:05.664596
2	1	2	2023-11-18 17:01:29.228596	2023-12-25 13:11:48.113546
43	1	2	2023-12-25 13:11:51.527032	\N
44	3	5	2023-12-26 14:01:23.244326	\N
45	7	1	2023-12-26 14:02:49.6625	\N
46	7	2	2023-12-28 19:10:47.668051	\N
47	7	3	2024-01-10 09:25:29.831047	\N
48	8	2	2024-03-03 23:27:19.401789	2024-03-04 11:03:47.313152
51	12	29	2024-03-11 11:59:05.46179	\N
52	12	28	2024-03-14 13:20:51.33123	\N
53	12	30	2024-03-14 13:20:53.71959	\N
54	12	32	2024-03-14 13:20:56.309079	\N
55	12	33	2024-03-14 13:20:59.654946	\N
56	12	34	2024-03-14 13:21:14.170814	\N
57	12	35	2024-03-14 13:21:18.118199	\N
59	12	37	2024-03-14 13:21:24.183338	\N
60	12	38	2024-03-14 13:21:27.093163	\N
61	12	39	2024-03-14 13:21:29.115239	\N
62	12	40	2024-03-14 13:21:32.4777	\N
19	5	7	2023-11-30 14:43:36.204253	2024-03-17 12:47:42.359717
50	12	27	2024-03-11 11:59:03.172205	2024-03-18 19:40:10.90033
63	12	41	2024-03-14 13:21:34.569684	2024-03-18 19:40:16.403131
49	12	31	2024-03-11 11:58:59.164967	2024-03-21 11:37:11.771007
64	1	6	2024-03-22 10:09:57.631918	2024-03-22 10:11:36.060439
65	1	6	2024-03-22 10:11:49.124962	2024-03-22 10:12:02.125639
66	1	6	2024-03-22 10:21:48.562016	\N
67	13	12	2024-04-03 12:17:57.483091	2024-04-03 14:37:12.143063
68	13	12	2024-04-03 14:37:16.553337	2024-04-03 14:38:47.691129
69	13	12	2024-04-03 14:38:52.218409	2024-04-03 14:40:54.478607
70	13	12	2024-04-03 14:40:59.136054	2024-04-03 14:42:08.564312
71	13	12	2024-04-03 14:42:12.998005	2024-04-03 14:43:53.666815
72	13	12	2024-04-03 14:43:58.077663	2024-04-03 14:45:24.715887
73	13	12	2024-04-03 14:45:29.306765	2024-04-03 14:55:36.783577
74	13	12	2024-04-03 14:55:41.102929	2024-04-03 14:56:30.751269
75	13	12	2024-04-03 14:56:35.15361	2024-04-03 14:57:16.717444
76	13	12	2024-04-03 14:57:21.143653	2024-04-03 15:06:40.288649
77	13	12	2024-04-03 15:06:44.877803	2024-04-03 15:10:12.839915
79	12	41	2024-04-03 17:35:44.075594	\N
78	13	12	2024-04-03 15:10:17.307357	2024-04-04 08:54:58.635556
80	13	12	2024-04-04 08:55:03.172321	2024-04-04 08:55:29.111088
81	13	12	2024-04-04 08:55:34.099498	2024-04-04 09:24:55.978254
82	13	12	2024-04-04 09:24:56.872049	2024-04-04 09:26:28.849902
83	13	12	2024-04-04 09:26:29.756745	2024-04-04 09:36:22.357269
84	13	12	2024-04-04 09:36:26.980177	2024-04-04 09:37:44.439046
85	13	12	2024-04-04 09:37:45.34451	2024-04-04 09:38:07.909662
86	13	12	2024-04-04 09:38:08.848795	2024-04-04 09:38:19.432739
87	13	12	2024-04-04 09:38:23.492997	2024-04-04 09:47:47.620225
88	13	12	2024-04-04 09:47:51.785752	2024-04-04 09:48:44.437496
89	13	12	2024-04-04 09:48:48.586886	2024-04-04 09:49:31.080054
90	13	12	2024-04-04 09:49:31.980458	2024-04-04 09:49:42.621157
91	13	12	2024-04-04 09:49:45.255462	2024-04-04 09:49:49.193337
92	13	12	2024-04-04 09:49:51.946122	2024-04-04 09:56:30.559005
93	13	12	2024-04-04 10:01:21.566043	2024-04-04 10:01:41.689322
94	13	12	2024-04-04 10:01:42.619628	2024-04-04 10:01:53.317111
95	13	12	2024-04-04 10:01:55.833655	2024-04-04 10:01:58.931006
96	13	12	2024-04-04 10:02:01.440666	2024-04-04 10:02:05.353419
97	13	12	2024-04-04 10:02:07.94773	2024-04-04 10:05:56.131786
98	13	12	2024-04-04 10:05:57.081215	2024-04-04 10:06:08.560629
99	13	12	2024-04-04 10:06:11.090214	2024-04-04 10:06:15.011712
100	13	12	2024-04-04 10:06:17.410526	2024-04-04 10:06:21.984147
101	13	12	2024-04-04 10:06:24.65524	2024-04-05 10:43:08.583423
102	13	12	2024-04-05 10:43:13.21632	2024-04-05 10:53:57.792279
103	13	12	2024-04-05 10:53:58.760519	2024-04-05 10:54:42.454446
104	13	12	2024-04-05 10:54:43.40007	2024-04-05 11:02:37.967257
105	13	12	2024-04-05 11:02:38.899214	2024-04-05 11:07:24.062856
106	13	12	2024-04-05 11:07:24.910111	2024-04-05 11:08:29.976378
107	13	12	2024-04-05 11:08:30.913095	2024-04-05 11:21:38.934921
108	13	12	2024-04-05 11:21:39.907292	2024-04-05 11:22:08.016507
109	13	12	2024-04-05 11:22:08.905746	2024-04-05 11:23:34.711358
110	13	12	2024-04-05 11:23:35.639728	2024-04-05 11:24:05.840793
111	13	12	2024-04-05 11:24:06.693583	2024-04-05 11:24:17.950432
112	13	12	2024-04-05 11:24:20.490175	2024-04-05 11:24:24.189911
121	13	12	2024-04-07 05:08:41.831065	2024-04-07 05:08:42.109217
199	13	12	2024-04-08 08:57:48.345347	2024-04-08 09:07:12.74773
122	13	12	2024-04-07 05:08:46.146261	2024-04-08 07:34:17.427839
200	13	12	2024-04-08 09:07:13.410236	2024-04-08 09:07:21.534154
123	13	12	2024-04-08 07:34:18.34207	2024-04-08 07:34:29.80109
310	13	12	2024-04-09 11:01:32.790716	2024-04-09 11:01:39.801446
124	13	12	2024-04-08 07:34:32.64665	2024-04-08 07:34:36.469179
201	13	12	2024-04-08 09:07:23.249957	2024-04-08 09:07:25.969815
125	13	12	2024-04-08 07:34:39.206031	2024-04-08 07:34:47.090377
126	13	12	2024-04-08 07:34:49.638821	2024-04-08 07:34:54.144317
202	13	12	2024-04-08 09:07:27.690138	2024-04-08 09:07:32.839262
127	13	12	2024-04-08 07:34:56.899586	2024-04-08 07:35:03.887872
128	13	12	2024-04-08 07:35:04.853469	2024-04-08 07:35:13.629035
203	13	12	2024-04-08 09:07:34.507802	2024-04-08 09:07:37.744913
129	13	12	2024-04-08 07:35:14.569531	2024-04-08 07:35:14.829067
130	13	12	2024-04-08 07:35:16.683893	2024-04-08 07:35:23.736277
204	13	12	2024-04-08 09:07:39.463525	2024-04-08 09:07:44.025307
131	13	12	2024-04-08 07:35:24.721765	2024-04-08 07:35:36.588322
132	13	12	2024-04-08 07:35:37.506258	2024-04-08 07:35:50.125348
205	13	12	2024-04-08 09:07:44.676947	2024-04-08 09:07:50.317265
133	13	12	2024-04-08 07:44:21.346368	2024-04-08 07:44:25.487556
134	13	12	2024-04-08 07:44:26.154783	2024-04-08 07:44:28.278686
206	13	12	2024-04-08 09:07:50.964628	2024-04-08 09:07:51.143358
135	13	12	2024-04-08 07:44:34.486534	2024-04-08 07:44:34.497564
136	13	12	2024-04-08 07:44:40.074017	2024-04-08 07:44:41.796359
207	13	12	2024-04-08 09:07:52.357411	2024-04-08 09:07:56.945502
137	13	12	2024-04-08 07:44:43.186166	2024-04-08 07:44:45.882371
138	13	12	2024-04-08 07:44:46.585378	2024-04-08 07:44:46.765634
208	13	12	2024-04-08 09:07:57.609402	2024-04-08 09:08:05.222898
139	13	12	2024-04-08 07:44:51.935516	2024-04-08 07:44:55.362659
140	13	12	2024-04-08 07:52:31.21963	2024-04-08 07:52:32.095667
209	13	12	2024-04-08 09:08:05.868605	2024-04-08 09:08:13.736425
141	13	12	2024-04-08 07:54:22.361785	2024-04-08 07:54:23.111007
142	13	12	2024-04-08 07:55:04.028053	2024-04-08 07:55:19.600568
210	13	12	2024-04-08 09:09:15.261028	2024-04-08 09:09:15.739445
143	13	12	2024-04-08 08:02:42.336362	2024-04-08 08:02:43.127904
144	13	12	2024-04-08 08:02:47.261823	2024-04-08 08:12:14.219399
211	13	12	2024-04-08 09:09:16.322945	2024-04-08 09:09:23.398931
145	13	12	2024-04-08 08:12:14.677457	2024-04-08 08:12:20.037474
146	13	12	2024-04-08 08:12:21.144357	2024-04-08 08:12:22.887428
212	13	12	2024-04-08 09:09:24.926528	2024-04-08 09:09:27.39858
147	13	12	2024-04-08 08:12:23.994363	2024-04-08 08:12:27.236759
148	13	12	2024-04-08 08:12:28.275924	2024-04-08 08:12:30.373644
213	13	12	2024-04-08 09:09:28.910457	2024-04-08 09:09:33.586841
149	13	12	2024-04-08 08:12:31.436723	2024-04-08 08:12:34.265131
150	13	12	2024-04-08 08:12:34.73933	2024-04-08 08:12:38.275235
214	13	12	2024-04-08 09:09:35.131049	2024-04-08 09:09:38.049869
151	13	12	2024-04-08 08:12:38.807232	2024-04-08 08:12:38.917504
152	13	12	2024-04-08 08:12:39.648046	2024-04-08 08:12:42.518592
215	13	12	2024-04-08 09:09:39.582718	2024-04-08 09:09:43.637741
153	13	12	2024-04-08 08:12:42.960524	2024-04-08 08:12:47.645846
154	13	12	2024-04-08 08:12:48.085533	2024-04-08 08:12:53.019629
216	13	12	2024-04-08 09:09:44.246029	2024-04-08 09:09:49.356998
155	13	12	2024-04-08 08:23:47.835737	2024-04-08 08:23:48.178405
156	13	12	2024-04-08 08:23:52.278201	2024-04-08 08:23:52.612941
217	13	12	2024-04-08 09:09:50.054803	2024-04-08 09:09:50.222974
157	13	12	2024-04-08 08:23:53.099651	2024-04-08 08:23:56.956549
158	13	12	2024-04-08 08:23:58.06729	2024-04-08 08:23:59.956409
218	13	12	2024-04-08 09:09:51.319096	2024-04-08 09:09:55.511196
159	13	12	2024-04-08 08:24:01.141581	2024-04-08 08:24:04.619307
160	13	12	2024-04-08 08:24:05.692389	2024-04-08 08:24:07.853556
219	13	12	2024-04-08 09:09:56.125233	2024-04-08 09:10:03.159016
161	13	12	2024-04-08 08:24:08.988846	2024-04-08 08:24:11.960512
162	13	12	2024-04-08 08:24:12.410978	2024-04-08 08:24:16.235476
220	13	12	2024-04-08 09:10:03.773984	2024-04-08 09:10:10.921909
163	13	12	2024-04-08 08:24:16.690198	2024-04-08 08:24:16.803637
164	13	12	2024-04-08 08:24:17.560505	2024-04-08 08:24:20.597537
221	13	12	2024-04-08 09:12:36.586456	2024-04-08 09:12:37.11719
165	13	12	2024-04-08 08:24:21.059818	2024-04-08 08:24:25.847548
166	13	12	2024-04-08 08:24:26.301019	2024-04-08 08:26:23.537284
222	13	12	2024-04-08 09:12:37.761952	2024-04-08 09:12:45.392161
167	13	12	2024-04-08 08:26:23.996842	2024-04-08 08:26:29.482484
168	13	12	2024-04-08 08:26:30.562976	2024-04-08 08:26:32.363722
223	13	12	2024-04-08 09:12:47.064458	2024-04-08 09:12:49.77813
169	13	12	2024-04-08 08:26:33.466746	2024-04-08 08:26:36.781008
170	13	12	2024-04-08 08:26:37.830676	2024-04-08 08:26:39.848585
224	13	12	2024-04-08 09:12:51.484639	2024-04-08 09:12:56.632654
171	13	12	2024-04-08 08:26:40.948835	2024-04-08 08:26:43.748596
172	13	12	2024-04-08 08:26:44.31259	2024-04-08 08:26:47.852287
225	13	12	2024-04-08 09:12:58.325062	2024-04-08 09:13:01.558539
173	13	12	2024-04-08 08:26:48.306389	2024-04-08 08:26:48.419568
174	13	12	2024-04-08 08:26:49.170176	2024-04-08 08:26:52.017245
226	13	12	2024-04-08 09:13:03.283034	2024-04-08 09:13:07.771318
175	13	12	2024-04-08 08:26:52.484231	2024-04-08 08:26:57.151926
176	13	12	2024-04-08 08:26:57.618743	2024-04-08 08:27:02.672574
227	13	12	2024-04-08 09:13:08.437631	2024-04-08 09:13:14.085269
177	13	12	2024-04-08 08:27:45.244551	2024-04-08 08:27:45.770645
178	13	12	2024-04-08 08:27:46.422803	2024-04-08 08:27:53.965289
228	13	12	2024-04-08 09:13:14.727656	2024-04-08 09:13:14.906298
179	13	12	2024-04-08 08:27:55.69886	2024-04-08 08:27:58.400186
180	13	12	2024-04-08 08:28:00.104797	2024-04-08 08:28:05.373414
229	13	12	2024-04-08 09:13:16.124932	2024-04-08 09:13:20.717659
181	13	12	2024-04-08 08:28:07.043346	2024-04-08 08:28:10.316664
182	13	12	2024-04-08 08:28:12.021065	2024-04-08 08:28:16.533273
230	13	12	2024-04-08 09:13:21.357535	2024-04-08 09:13:28.827457
183	13	12	2024-04-08 08:28:17.186195	2024-04-08 08:28:22.852504
184	13	12	2024-04-08 08:28:23.522981	2024-04-08 08:28:23.696545
231	13	12	2024-04-08 09:13:29.495543	2024-04-08 09:13:37.448361
185	13	12	2024-04-08 08:28:24.896104	2024-04-08 08:28:29.535512
186	13	12	2024-04-08 08:28:30.208637	2024-04-08 08:28:37.704841
232	13	12	2024-04-08 09:35:35.845475	2024-04-08 09:35:36.956753
187	13	12	2024-04-08 08:28:38.357344	2024-04-08 08:28:46.303284
188	13	12	2024-04-08 08:57:11.063088	2024-04-08 08:57:11.415382
233	13	12	2024-04-08 09:35:44.238663	2024-04-08 09:35:44.953035
189	13	12	2024-04-08 08:57:15.455974	2024-04-08 08:57:15.787425
190	13	12	2024-04-08 08:57:16.22805	2024-04-08 08:57:20.027373
234	13	12	2024-04-08 09:35:45.7291	2024-04-08 09:35:52.948731
191	13	12	2024-04-08 08:57:21.106828	2024-04-08 08:57:22.892337
192	13	12	2024-04-08 08:57:24.026811	2024-04-08 08:57:27.304837
235	13	12	2024-04-08 09:35:54.830473	2024-04-08 09:35:57.912597
193	13	12	2024-04-08 08:57:28.370267	2024-04-08 08:57:30.497906
194	13	12	2024-04-08 08:57:31.617998	2024-04-08 08:57:34.475708
236	13	12	2024-04-08 09:35:59.840989	2024-04-08 09:36:05.846564
195	13	12	2024-04-08 08:57:34.921844	2024-04-08 08:57:38.486472
196	13	12	2024-04-08 08:57:38.950227	2024-04-08 08:57:39.056791
197	13	12	2024-04-08 08:57:39.795653	2024-04-08 08:57:42.73776
198	13	12	2024-04-08 08:57:43.190155	2024-04-08 08:57:47.889909
237	13	12	2024-04-08 09:36:07.632135	2024-04-08 09:36:11.153299
311	13	12	2024-04-09 11:01:40.732665	2024-04-09 11:01:49.486955
238	13	12	2024-04-08 09:36:12.967266	2024-04-08 09:36:17.74061
448	13	12	2024-04-10 11:05:56.934062	2024-04-10 11:05:57.363881
239	13	12	2024-04-08 09:36:18.430127	2024-04-08 09:36:24.506302
312	13	12	2024-04-09 11:01:50.424299	2024-04-09 11:01:50.711025
240	13	12	2024-04-08 09:36:25.224699	2024-04-08 09:36:25.429374
241	13	12	2024-04-08 09:36:26.737283	2024-04-08 09:36:31.663244
313	13	12	2024-04-09 11:01:52.688808	2024-04-09 11:01:59.605693
242	13	12	2024-04-08 09:36:32.346047	2024-04-08 09:36:40.30387
243	13	12	2024-04-08 09:36:40.994751	2024-04-09 09:08:35.566303
314	13	12	2024-04-09 11:02:00.546266	2024-04-09 11:02:12.013496
244	13	12	2024-04-09 09:08:36.499742	2024-04-09 09:08:47.789335
245	13	12	2024-04-09 09:08:49.745485	2024-04-09 09:08:53.12559
315	13	12	2024-04-09 11:02:13.006131	2024-04-09 11:11:37.690432
246	13	12	2024-04-09 09:08:55.142539	2024-04-09 09:09:01.157209
247	13	12	2024-04-09 09:09:03.170272	2024-04-09 09:09:06.9056
316	13	12	2024-04-09 11:11:39.520731	2024-04-09 11:11:52.449342
248	13	12	2024-04-09 09:09:08.820602	2024-04-09 09:09:13.805905
249	13	12	2024-04-09 09:09:14.524188	2024-04-09 09:09:20.698078
317	13	12	2024-04-09 11:11:56.241449	2024-04-09 11:12:00.726468
250	13	12	2024-04-09 09:09:21.418925	2024-04-09 09:09:21.660907
251	13	12	2024-04-09 09:09:22.961977	2024-04-09 09:09:27.994042
318	13	12	2024-04-09 11:12:04.735154	2024-04-09 11:12:13.501108
252	13	12	2024-04-09 09:09:28.688665	2024-04-09 09:09:36.789262
253	13	12	2024-04-09 09:09:37.503976	2024-04-09 09:09:46.063053
319	13	12	2024-04-09 11:12:33.849363	2024-04-09 11:12:38.951514
254	13	12	2024-04-09 09:17:18.413784	2024-04-09 09:17:19.355798
255	13	12	2024-04-09 09:21:32.418653	2024-04-09 09:21:33.346246
320	13	12	2024-04-09 11:12:41.54977	2024-04-09 11:12:48.967458
256	13	12	2024-04-09 09:22:17.958014	2024-04-09 09:22:18.86222
257	13	12	2024-04-09 09:43:16.63518	2024-04-09 09:43:17.517157
321	13	12	2024-04-09 11:12:49.926961	2024-04-09 11:12:58.985453
258	13	12	2024-04-09 09:43:18.531713	2024-04-09 09:43:31.023946
259	13	12	2024-04-09 09:43:33.630118	2024-04-09 09:43:38.222321
322	13	12	2024-04-09 11:12:59.888895	2024-04-09 11:13:00.191166
260	13	12	2024-04-09 09:43:40.978421	2024-04-09 09:43:49.207704
261	13	12	2024-04-09 09:43:51.83344	2024-04-09 09:43:56.818369
323	13	12	2024-04-09 11:13:02.028608	2024-04-09 11:13:09.180081
262	13	12	2024-04-09 09:44:01.538623	2024-04-09 09:44:02.47454
263	13	12	2024-04-09 09:44:03.403264	2024-04-09 09:44:12.323725
324	13	12	2024-04-09 11:13:10.157289	2024-04-09 11:13:21.960628
264	13	12	2024-04-09 09:44:13.271598	2024-04-09 09:44:13.854117
265	13	12	2024-04-09 09:44:15.99151	2024-04-09 09:44:23.199052
325	13	12	2024-04-09 11:13:22.934003	2024-04-09 11:35:47.597907
266	13	12	2024-04-09 09:44:24.189983	2024-04-09 09:44:36.536569
267	13	12	2024-04-09 09:44:37.524819	2024-04-09 09:45:02.936297
326	13	12	2024-04-09 11:35:48.613636	2024-04-09 11:36:00.986873
268	13	12	2024-04-09 09:46:00.000346	2024-04-09 09:46:00.84859
269	13	12	2024-04-09 09:47:08.893379	2024-04-09 09:47:09.646069
327	13	12	2024-04-09 11:36:03.688986	2024-04-09 11:36:07.946266
270	13	12	2024-04-09 09:47:13.924895	2024-04-09 10:25:27.697166
271	13	12	2024-04-09 10:25:28.652328	2024-04-09 10:25:40.649194
328	13	12	2024-04-09 11:36:10.49811	2024-04-09 11:36:18.223189
272	13	12	2024-04-09 10:25:43.327301	2024-04-09 10:25:47.505244
273	13	12	2024-04-09 10:25:50.055126	2024-04-09 10:25:57.937195
329	13	12	2024-04-09 11:36:20.724322	2024-04-09 11:36:25.532157
274	13	12	2024-04-09 10:26:00.454116	2024-04-09 10:26:05.299767
275	13	12	2024-04-09 10:26:07.938181	2024-04-09 10:26:15.247112
330	13	12	2024-04-09 11:36:27.983648	2024-04-09 11:36:35.503369
276	13	12	2024-04-09 10:26:16.209191	2024-04-09 10:26:24.963152
277	13	12	2024-04-09 10:26:25.909211	2024-04-09 10:26:26.202912
331	13	12	2024-04-09 11:36:36.438667	2024-04-09 11:36:45.205949
278	13	12	2024-04-09 10:26:28.10398	2024-04-09 10:26:35.184332
279	13	12	2024-04-09 10:26:36.110587	2024-04-09 10:26:47.985238
332	13	12	2024-04-09 11:36:46.143805	2024-04-09 11:36:46.446529
280	13	12	2024-04-09 10:26:48.924922	2024-04-09 10:27:14.06538
281	13	12	2024-04-09 10:27:23.623229	2024-04-09 10:33:01.210141
333	13	12	2024-04-09 11:36:48.358225	2024-04-09 11:36:55.571132
282	13	12	2024-04-09 10:33:05.526378	2024-04-09 10:34:06.680968
283	13	12	2024-04-09 10:34:10.864257	2024-04-09 10:34:52.136784
334	13	12	2024-04-09 11:36:56.56665	2024-04-09 11:37:08.614843
284	13	12	2024-04-09 10:34:56.341469	2024-04-09 10:44:42.936212
285	13	12	2024-04-09 10:44:43.886103	2024-04-09 10:44:55.335894
335	13	12	2024-04-09 11:37:09.577945	2024-04-09 11:38:57.395793
286	13	12	2024-04-09 10:44:58.950833	2024-04-09 10:44:59.729479
287	13	12	2024-04-09 10:45:02.40057	2024-04-09 10:45:10.329434
336	13	12	2024-04-09 11:38:58.309611	2024-04-09 11:41:18.19301
288	13	12	2024-04-09 10:45:14.417144	2024-04-09 10:45:15.196505
289	13	12	2024-04-09 10:45:18.023413	2024-04-09 10:45:24.871202
337	13	12	2024-04-09 11:41:18.662247	2024-04-09 11:41:24.304292
290	13	12	2024-04-09 10:45:25.760941	2024-04-09 10:45:34.42112
291	13	12	2024-04-09 10:45:35.345059	2024-04-09 10:45:35.61769
338	13	12	2024-04-09 11:41:25.397642	2024-04-09 11:41:27.272475
292	13	12	2024-04-09 10:45:37.569955	2024-04-09 10:45:45.592715
293	13	12	2024-04-09 10:45:46.497935	2024-04-09 10:45:52.949429
339	13	12	2024-04-09 11:41:28.354589	2024-04-09 11:41:31.650936
294	13	12	2024-04-09 10:45:54.125333	2024-04-09 10:46:46.471517
295	13	12	2024-04-09 10:46:50.514096	2024-04-09 10:47:41.355442
340	13	12	2024-04-09 11:41:32.696882	2024-04-09 11:41:34.818029
296	13	12	2024-04-09 10:47:42.309643	2024-04-09 10:47:54.304049
297	13	12	2024-04-09 10:47:56.87766	2024-04-09 10:48:01.430535
341	13	12	2024-04-09 11:41:35.908948	2024-04-09 11:41:38.897962
298	13	12	2024-04-09 10:48:04.057427	2024-04-09 10:48:12.833612
299	13	12	2024-04-09 10:48:16.094317	2024-04-09 10:48:20.9207
342	13	12	2024-04-09 11:41:39.344654	2024-04-09 11:41:42.951973
300	13	12	2024-04-09 10:48:24.208782	2024-04-09 10:48:31.339041
301	13	12	2024-04-09 10:48:32.306175	2024-04-09 10:48:40.939179
343	13	12	2024-04-09 11:41:43.388422	2024-04-09 11:41:43.522127
302	13	12	2024-04-09 10:48:41.882478	2024-04-09 10:48:42.164798
303	13	12	2024-04-09 10:48:43.972037	2024-04-09 10:48:50.976761
344	13	12	2024-04-09 11:41:44.264206	2024-04-09 11:41:47.190148
304	13	12	2024-04-09 10:48:51.908632	2024-04-09 10:49:03.524445
305	13	12	2024-04-09 10:49:04.48544	2024-04-09 11:00:52.768928
345	13	12	2024-04-09 11:41:47.628997	2024-04-09 11:41:52.405484
306	13	12	2024-04-09 11:00:53.726319	2024-04-09 11:01:05.349042
307	13	12	2024-04-09 11:01:07.962736	2024-04-09 11:01:12.489063
346	13	12	2024-04-09 11:41:52.852733	2024-04-09 11:41:57.795593
308	13	12	2024-04-09 11:01:14.971394	2024-04-09 11:01:22.940579
309	13	12	2024-04-09 11:01:25.508066	2024-04-09 11:01:30.337113
347	13	12	2024-04-09 12:03:26.745103	2024-04-09 12:03:27.773063
348	13	12	2024-04-09 12:03:28.448617	2024-04-09 12:03:35.449213
349	13	12	2024-04-09 12:03:37.573139	2024-04-09 12:03:38.126243
350	13	12	2024-04-09 12:03:41.057172	2024-04-09 12:03:41.580899
351	13	12	2024-04-09 12:03:41.995171	2024-04-09 12:03:44.988881
352	13	12	2024-04-09 12:03:47.277576	2024-04-09 12:03:47.81951
353	13	12	2024-04-09 12:03:49.845395	2024-04-09 12:03:50.505612
354	13	12	2024-04-09 12:03:52.433624	2024-04-09 12:03:52.925152
627	13	12	2024-08-01 15:14:47.498348	2024-08-01 15:14:48.048214
355	13	12	2024-04-09 12:03:53.441022	2024-04-09 12:03:53.605693
356	13	12	2024-04-09 12:03:56.077612	2024-04-09 12:03:56.542277
449	13	12	2024-04-10 11:05:57.883285	2024-04-10 11:06:04.071634
357	13	12	2024-04-09 12:03:58.517466	2024-04-09 12:03:58.927227
359	13	12	2024-04-09 12:07:51.489449	2024-04-09 12:07:52.288667
450	13	12	2024-04-10 11:06:05.332862	2024-04-10 11:06:07.509705
360	13	12	2024-04-09 12:07:53.19414	2024-04-09 12:08:04.817524
361	13	12	2024-04-09 12:08:07.447501	2024-04-09 12:08:11.422874
451	13	12	2024-04-10 11:06:08.800736	2024-04-10 11:06:12.733869
362	13	12	2024-04-09 12:08:14.228295	2024-04-09 12:08:22.061633
363	13	12	2024-04-09 12:08:24.597734	2024-04-09 12:08:29.276471
454	13	12	2024-04-10 11:06:21.796764	2024-04-10 11:06:26.126593
364	13	12	2024-04-09 12:08:32.102876	2024-04-09 12:08:39.516937
365	13	12	2024-04-09 12:08:40.464963	2024-04-09 12:08:49.602726
455	13	12	2024-04-10 11:06:26.662131	2024-04-10 11:06:26.80143
366	13	12	2024-04-09 12:08:50.517508	2024-04-09 12:08:50.784992
367	13	12	2024-04-09 12:08:52.806225	2024-04-09 12:08:59.956045
456	13	12	2024-04-10 11:06:27.718316	2024-04-10 11:06:31.270334
368	13	12	2024-04-09 12:09:00.889258	2024-04-09 12:09:12.918476
369	13	12	2024-04-09 12:09:13.883526	2024-04-09 12:09:28.258454
457	13	12	2024-04-10 11:06:31.798915	2024-04-10 11:06:37.583519
458	13	12	2024-04-10 11:06:38.112365	2024-04-10 11:06:44.248572
459	13	12	2024-04-10 11:08:27.772716	2024-04-10 11:08:28.177033
460	13	12	2024-04-10 11:08:28.697141	2024-04-10 11:08:34.88237
461	13	12	2024-04-10 11:08:36.173581	2024-04-10 11:08:38.29651
462	13	12	2024-04-10 11:08:39.617031	2024-04-10 11:08:43.490016
463	13	12	2024-04-10 11:08:44.717686	2024-04-10 11:08:47.18789
464	13	12	2024-04-10 11:08:48.46564	2024-04-10 11:08:51.965652
465	13	12	2024-04-10 11:08:52.475905	2024-04-10 11:08:56.738783
466	13	12	2024-04-10 11:08:57.261619	2024-04-10 11:08:57.399152
467	13	12	2024-04-10 11:08:58.373158	2024-04-10 11:09:02.037492
468	13	12	2024-04-10 11:09:02.613247	2024-04-10 11:09:08.257089
474	13	12	2024-04-10 11:12:49.237226	2024-04-10 11:12:52.654911
475	13	12	2024-04-10 11:12:54.4133	2024-04-10 11:12:59.333857
476	13	12	2024-04-10 11:13:00.017964	2024-04-10 11:13:05.863069
477	13	12	2024-04-10 11:13:06.565407	2024-04-10 11:13:06.761765
478	13	12	2024-04-10 11:13:07.997806	2024-04-10 11:13:12.77258
479	13	12	2024-04-10 11:13:13.476451	2024-04-10 11:13:21.334862
480	13	12	2024-04-10 11:13:22.028941	2024-04-10 11:13:30.330887
492	13	12	2024-04-12 18:36:18.920642	2024-04-12 18:36:20.143357
493	13	12	2024-04-12 18:36:21.095815	2024-04-12 18:36:31.264226
494	13	12	2024-04-12 18:36:32.911325	2024-04-12 18:36:35.901037
495	13	12	2024-04-12 18:36:37.488997	2024-04-12 18:36:42.4952
496	13	12	2024-04-12 18:36:43.959564	2024-04-12 18:36:47.119398
497	13	12	2024-04-12 18:36:48.812397	2024-04-12 18:36:53.1479
498	13	12	2024-04-12 18:36:53.836173	2024-04-12 18:36:59.073992
499	13	12	2024-04-12 18:36:59.717052	2024-04-12 18:36:59.913269
500	13	12	2024-04-12 18:37:00.997655	2024-04-12 18:37:05.255694
501	13	12	2024-04-12 18:37:05.885707	2024-04-12 18:37:12.712463
502	13	12	2024-04-12 18:37:13.339603	2024-04-12 18:37:20.320044
504	13	12	2024-04-22 15:27:10.845921	2024-04-22 15:27:11.350295
505	13	12	2024-04-22 15:27:11.884168	2024-04-22 15:27:18.135342
506	13	12	2024-04-22 15:27:19.316104	2024-04-22 15:27:21.350134
507	13	12	2024-04-22 15:27:22.581963	2024-04-22 15:27:26.146701
508	13	12	2024-04-22 15:27:27.283435	2024-04-22 15:27:29.631638
509	13	12	2024-04-22 15:27:30.808262	2024-04-22 15:27:34.139644
510	13	12	2024-04-22 15:27:34.669327	2024-04-22 15:27:38.563129
511	13	12	2024-04-22 15:27:39.145157	2024-04-22 15:27:39.288681
512	13	12	2024-04-22 15:27:40.07501	2024-04-22 15:27:43.306872
513	13	12	2024-04-22 15:27:43.792978	2024-04-22 15:27:48.805683
514	13	12	2024-04-22 15:27:49.330591	2024-04-22 15:27:54.731479
526	13	12	2024-04-23 18:15:57.335304	2024-04-23 18:15:58.583856
527	13	12	2024-04-23 18:15:59.575893	2024-04-23 18:16:10.997834
528	13	12	2024-04-23 18:16:12.914534	2024-04-23 18:16:16.210963
529	13	12	2024-04-23 18:16:18.136263	2024-04-23 18:16:24.042211
530	13	12	2024-04-23 18:16:25.959103	2024-04-23 18:16:29.596194
531	13	12	2024-04-23 18:16:31.441784	2024-04-23 18:16:36.518171
532	13	12	2024-04-23 18:16:37.234649	2024-04-23 18:16:43.373572
533	13	12	2024-04-23 18:16:44.102526	2024-04-23 18:16:44.329477
534	13	12	2024-04-23 18:16:45.598204	2024-04-23 18:16:50.600576
535	13	12	2024-04-23 18:16:51.352596	2024-04-23 18:16:59.555643
536	13	12	2024-04-23 18:17:00.293299	2024-04-23 18:17:08.846273
545	13	12	2024-04-23 19:00:57.091918	2024-04-23 19:01:01.797517
546	13	12	2024-04-23 19:01:02.517242	2024-04-23 19:01:09.288285
547	13	12	2024-04-23 19:01:09.905078	2024-04-23 19:01:16.776398
548	2	5	2024-05-14 10:49:55.11002	2024-05-14 10:50:10.184085
549	13	12	2024-06-16 07:21:01.026789	2024-06-16 07:21:02.018083
550	13	12	2024-06-16 07:21:07.920824	2024-06-16 07:21:08.601718
551	13	12	2024-06-16 07:21:09.429299	2024-06-16 07:21:16.438603
552	13	12	2024-06-16 07:21:18.316516	2024-06-16 07:21:21.653433
553	13	12	2024-06-16 07:21:23.578369	2024-06-16 07:21:29.481424
554	13	12	2024-06-16 07:21:31.358512	2024-06-16 07:21:35.033095
555	13	12	2024-06-16 07:21:36.850919	2024-06-16 07:21:41.989177
556	13	12	2024-06-16 07:21:42.816578	2024-06-16 07:21:49.070278
557	13	12	2024-06-16 07:21:49.82598	2024-06-16 07:21:50.056842
558	13	12	2024-06-16 07:21:51.370391	2024-06-16 07:21:56.435057
559	13	12	2024-06-16 07:21:57.176112	2024-06-16 07:22:05.338454
560	13	12	2024-06-16 07:22:06.075952	2024-07-05 16:16:35.262153
561	13	12	2024-07-05 16:16:41.715304	2024-07-05 16:16:42.580013
562	13	12	2024-07-05 16:16:43.395493	2024-07-05 16:16:49.888111
563	13	12	2024-07-05 16:16:51.30386	2024-07-05 16:16:54.243344
564	13	12	2024-07-05 16:16:55.744255	2024-07-05 16:17:00.2655
565	13	12	2024-07-05 16:17:01.92565	2024-07-05 16:17:04.9524
566	13	12	2024-07-05 16:17:06.402072	2024-07-05 16:17:10.216261
567	13	12	2024-07-05 16:17:10.874627	2024-07-05 16:17:15.686935
568	13	12	2024-07-05 16:17:16.289399	2024-07-05 16:17:16.551151
569	13	12	2024-07-05 16:17:17.406154	2024-07-05 16:17:21.035397
570	13	12	2024-07-05 16:17:21.625494	2024-07-05 16:17:27.373207
572	12	36	2024-07-08 12:06:43.728928	\N
571	13	12	2024-07-05 16:17:27.907822	2024-07-18 19:28:24.6372
573	13	12	2024-07-18 19:28:25.877705	2024-07-18 19:28:37.951941
574	13	12	2024-07-18 19:28:40.035515	2024-07-18 19:28:43.846534
575	13	12	2024-07-18 19:28:46.018393	2024-07-18 19:28:52.430049
576	13	12	2024-07-18 19:28:54.307552	2024-07-18 19:28:58.133432
577	13	12	2024-07-18 19:29:00.010282	2024-07-18 19:29:05.489999
578	13	12	2024-07-18 19:29:06.236385	2024-07-18 19:29:13.018888
579	13	12	2024-07-18 19:29:13.784602	2024-07-18 19:29:14.01899
580	13	12	2024-07-18 19:29:15.44722	2024-07-18 19:29:20.753599
581	13	12	2024-07-18 19:29:21.492206	2024-07-18 19:29:30.159948
582	13	12	2024-07-18 19:29:30.976262	2024-07-18 19:29:39.785532
583	13	12	2024-07-19 07:24:39.017174	2024-07-19 07:24:40.524775
584	13	12	2024-07-19 07:24:41.607439	2024-07-19 07:24:53.399321
358	13	12	2024-04-09 12:04:00.924797	2024-04-09 12:04:01.370944
370	13	12	2024-04-09 12:12:23.706448	2024-04-09 12:12:24.589305
452	13	12	2024-04-10 11:06:14.002454	2024-04-10 11:06:16.457853
371	13	12	2024-04-09 12:12:25.558074	2024-04-09 12:12:37.169314
372	13	12	2024-04-09 12:12:39.794062	2024-04-09 12:12:44.049756
453	13	12	2024-04-10 11:06:17.776411	2024-04-10 11:06:21.241292
373	13	12	2024-04-09 12:12:46.544358	2024-04-09 12:12:54.805182
374	13	12	2024-04-09 12:12:57.505959	2024-04-09 12:13:02.464609
469	13	12	2024-04-10 11:09:08.768697	2024-04-10 11:09:14.610314
375	13	12	2024-04-09 12:13:05.074728	2024-04-09 12:13:12.516417
376	13	12	2024-04-09 12:13:13.471744	2024-04-09 12:13:23.681916
470	13	12	2024-04-10 11:12:26.577145	2024-04-10 11:12:27.144349
377	13	12	2024-04-09 12:13:24.628678	2024-04-09 12:13:24.926326
378	13	12	2024-04-09 12:13:26.960074	2024-04-09 12:13:34.821749
471	13	12	2024-04-10 11:12:27.969253	2024-04-10 11:12:35.620317
379	13	12	2024-04-09 12:13:35.781199	2024-04-09 12:13:47.740419
380	13	12	2024-04-09 12:13:48.742591	2024-04-09 12:14:01.995056
472	13	12	2024-04-10 11:12:37.378163	2024-04-10 11:12:40.299896
381	13	12	2024-04-09 12:18:07.212157	2024-04-09 12:18:07.618359
382	13	12	2024-04-09 12:18:08.123676	2024-04-09 12:18:14.105321
473	13	12	2024-04-10 11:12:42.090428	2024-04-10 11:12:47.457346
383	13	12	2024-04-09 12:18:15.267146	2024-04-09 12:18:17.193141
384	13	12	2024-04-09 12:18:18.379395	2024-04-09 12:18:21.880407
481	13	12	2024-04-10 11:19:18.335299	2024-04-10 11:19:19.445853
385	13	12	2024-04-09 12:18:23.009089	2024-04-09 12:18:25.237908
386	13	12	2024-04-09 12:18:26.420918	2024-04-09 12:18:29.570028
482	13	12	2024-04-10 11:19:20.298973	2024-04-10 11:19:29.876042
387	13	12	2024-04-09 12:18:30.047904	2024-04-09 12:18:33.838846
388	13	12	2024-04-09 12:18:34.315465	2024-04-09 12:18:34.442743
483	13	12	2024-04-10 11:19:31.600705	2024-04-10 11:19:34.550676
389	13	12	2024-04-09 12:18:35.233694	2024-04-09 12:18:38.384231
390	13	12	2024-04-09 12:18:38.84908	2024-04-09 12:18:43.941285
484	13	12	2024-04-10 11:19:36.243236	2024-04-10 11:19:41.367132
391	13	12	2024-04-09 12:18:44.409605	2024-04-09 12:18:49.703014
392	13	12	2024-04-09 12:19:51.424906	2024-04-09 12:19:51.858972
485	13	12	2024-04-10 11:19:42.91276	2024-04-10 11:19:46.018867
393	13	12	2024-04-09 12:19:52.391145	2024-04-09 12:19:58.731263
394	13	12	2024-04-09 12:20:00.024323	2024-04-09 12:20:02.341034
486	13	12	2024-04-10 11:19:47.736127	2024-04-10 11:19:52.1881
395	13	12	2024-04-09 12:20:03.757889	2024-04-09 12:20:07.89946
396	13	12	2024-04-09 12:20:09.153128	2024-04-09 12:20:11.66451
487	13	12	2024-04-10 11:19:52.870397	2024-04-10 11:19:58.013422
397	13	12	2024-04-09 12:20:13.002532	2024-04-09 12:20:16.55401
398	13	12	2024-04-09 12:20:17.076255	2024-04-09 12:20:21.409519
488	13	12	2024-04-10 11:19:58.64257	2024-04-10 11:19:58.838941
399	13	12	2024-04-09 12:20:21.938972	2024-04-09 12:20:22.089743
400	13	12	2024-04-09 12:20:23.050912	2024-04-09 12:20:26.585653
489	13	12	2024-04-10 11:19:59.92469	2024-04-10 11:20:04.370553
401	13	12	2024-04-09 12:20:27.096547	2024-04-09 12:20:32.758775
402	13	12	2024-04-09 12:20:33.294952	2024-04-09 12:20:39.34216
490	13	12	2024-04-10 11:20:05.043146	2024-04-10 11:20:11.739956
403	13	12	2024-04-10 02:26:06.75258	2024-04-10 02:26:07.232611
404	13	12	2024-04-10 02:26:07.756406	2024-04-10 02:26:13.975262
491	13	12	2024-04-10 11:20:12.353754	2024-04-10 11:20:19.348458
405	13	12	2024-04-10 02:26:15.133935	2024-04-10 02:26:17.089162
503	12	27	2024-04-14 23:37:47.424661	\N
406	13	12	2024-04-10 02:26:18.261113	2024-04-10 02:26:21.753696
407	13	12	2024-04-10 02:26:22.871197	2024-04-10 02:26:25.194923
515	13	12	2024-04-23 02:13:37.680069	2024-04-23 02:13:38.878611
408	13	12	2024-04-10 02:26:26.330689	2024-04-10 02:26:29.434878
409	13	12	2024-04-10 02:26:29.95542	2024-04-10 02:26:33.712188
516	13	12	2024-04-23 02:13:39.797968	2024-04-23 02:13:49.322953
410	13	12	2024-04-10 02:26:34.206965	2024-04-10 02:26:34.327586
411	13	12	2024-04-10 02:26:35.095411	2024-04-10 02:26:38.290896
517	13	12	2024-04-23 02:13:51.013711	2024-04-23 02:13:53.989681
412	13	12	2024-04-10 02:26:38.779547	2024-04-10 02:26:43.86275
413	13	12	2024-04-10 02:26:44.357134	2024-04-10 02:26:49.448745
518	13	12	2024-04-23 02:13:55.704673	2024-04-23 02:14:00.696449
414	13	12	2024-04-10 10:50:18.631796	2024-04-10 10:50:19.42487
415	13	12	2024-04-10 10:56:33.716101	2024-04-10 10:56:34.073698
519	13	12	2024-04-23 02:14:02.252896	2024-04-23 02:14:05.408912
416	13	12	2024-04-10 10:56:34.595618	2024-04-10 10:56:40.231215
417	13	12	2024-04-10 10:56:41.331624	2024-04-10 10:56:43.19323
520	13	12	2024-04-23 02:14:07.112574	2024-04-23 02:14:11.406914
418	13	12	2024-04-10 10:56:44.342034	2024-04-10 10:56:47.76611
419	13	12	2024-04-10 10:56:48.860877	2024-04-10 10:56:51.0726
521	13	12	2024-04-23 02:14:12.039581	2024-04-23 02:14:17.253637
420	13	12	2024-04-10 10:56:52.164694	2024-04-10 10:56:55.168376
421	13	12	2024-04-10 10:56:55.652842	2024-04-10 10:56:59.256327
522	13	12	2024-04-23 02:14:17.896829	2024-04-23 02:14:18.065272
422	13	12	2024-04-10 10:56:59.725769	2024-04-10 10:56:59.862965
423	13	12	2024-04-10 10:57:00.60095	2024-04-10 10:57:03.646404
523	13	12	2024-04-23 02:14:19.184004	2024-04-23 02:14:23.469723
424	13	12	2024-04-10 10:57:04.158109	2024-04-10 10:57:09.004502
425	13	12	2024-04-10 10:57:09.496613	2024-04-10 10:57:14.47675
524	13	12	2024-04-23 02:14:24.115132	2024-04-23 02:14:30.770272
426	13	12	2024-04-10 11:00:05.124439	2024-04-10 11:00:05.577068
427	13	12	2024-04-10 11:00:06.094384	2024-04-10 11:00:12.001619
525	13	12	2024-04-23 02:14:31.402221	2024-04-23 02:14:38.603201
428	13	12	2024-04-10 11:00:13.17216	2024-04-10 11:00:15.107078
429	13	12	2024-04-10 11:00:16.292611	2024-04-10 11:00:19.842698
537	13	12	2024-04-23 19:00:15.33032	2024-04-23 19:00:17.346445
430	13	12	2024-04-10 11:00:20.977959	2024-04-10 11:00:23.32389
431	13	12	2024-04-10 11:00:24.504645	2024-04-10 11:00:27.779266
538	13	12	2024-04-23 19:00:18.384511	2024-04-23 19:00:27.893253
432	13	12	2024-04-10 11:00:28.27791	2024-04-10 11:00:32.06689
433	13	12	2024-04-10 11:00:32.557936	2024-04-10 11:00:32.691469
539	13	12	2024-04-23 19:00:29.646376	2024-04-23 19:00:32.71309
434	13	12	2024-04-10 11:00:33.468487	2024-04-10 11:00:36.61949
435	13	12	2024-04-10 11:00:37.101614	2024-04-10 11:00:42.052879
540	13	12	2024-04-23 19:00:34.385494	2024-04-23 19:00:39.355488
436	13	12	2024-04-10 11:00:42.685603	2024-04-10 11:00:47.909472
437	13	12	2024-04-10 11:01:19.412518	2024-04-10 11:01:19.839417
541	13	12	2024-04-23 19:00:40.866692	2024-04-23 19:00:44.091383
438	13	12	2024-04-10 11:01:20.328342	2024-04-10 11:01:26.181251
439	13	12	2024-04-10 11:01:27.35864	2024-04-10 11:01:29.296712
542	13	12	2024-04-23 19:00:45.618446	2024-04-23 19:00:49.726744
440	13	12	2024-04-10 11:01:30.518613	2024-04-10 11:01:33.913685
441	13	12	2024-04-10 11:01:35.017975	2024-04-10 11:01:37.277209
543	13	12	2024-04-23 19:00:50.346604	2024-04-23 19:00:55.281898
442	13	12	2024-04-10 11:01:38.411492	2024-04-10 11:01:41.520914
443	13	12	2024-04-10 11:01:41.997221	2024-04-10 11:01:45.760195
544	13	12	2024-04-23 19:00:55.887189	2024-04-23 19:00:56.057954
444	13	12	2024-04-10 11:01:46.244974	2024-04-10 11:01:46.371391
445	13	12	2024-04-10 11:01:47.143455	2024-04-10 11:01:50.235013
446	13	12	2024-04-10 11:01:50.7103	2024-04-10 11:01:55.537741
447	13	12	2024-04-10 11:01:56.008891	2024-04-10 11:02:01.252467
585	13	12	2024-07-19 07:24:55.303366	2024-07-19 07:24:58.896289
626	13	12	2024-08-01 14:40:35.676381	2024-08-01 14:40:41.906433
586	13	12	2024-07-19 07:25:00.715236	2024-07-19 07:25:07.136761
860	13	12	2024-09-19 18:38:32.069924	2024-09-19 18:38:32.551608
587	13	12	2024-07-19 07:25:08.808923	2024-07-19 07:25:12.356489
628	13	12	2024-08-01 15:14:48.70964	2024-08-01 15:14:55.689567
588	13	12	2024-07-19 07:25:14.118555	2024-07-19 07:25:18.765609
589	13	12	2024-07-19 07:25:19.490118	2024-07-19 07:25:25.118998
629	13	12	2024-08-01 15:14:57.164754	2024-08-01 15:14:59.656349
590	13	12	2024-07-19 07:25:25.798287	2024-07-19 07:25:26.043967
591	13	12	2024-07-19 07:25:27.141191	2024-07-19 07:25:31.740716
630	13	12	2024-08-01 15:15:01.245453	2024-08-01 15:15:05.998126
592	13	12	2024-07-19 07:25:32.462347	2024-07-19 07:25:39.863262
593	13	12	2024-07-19 07:25:40.483227	2024-07-19 07:25:47.722383
631	13	12	2024-08-01 15:15:07.646735	2024-08-01 15:15:10.567645
594	13	12	2024-08-01 14:29:25.823067	2024-08-01 14:29:26.494331
595	13	12	2024-08-01 14:29:27.345865	2024-08-01 14:29:34.62791
632	13	12	2024-08-01 15:15:12.060562	2024-08-01 15:15:16.213166
596	13	12	2024-08-01 14:29:36.036207	2024-08-01 14:29:38.466271
597	13	12	2024-08-01 14:29:39.933758	2024-08-01 14:29:44.241582
633	13	12	2024-08-01 15:15:16.821436	2024-08-01 15:15:21.756157
598	13	12	2024-08-01 14:29:45.578661	2024-08-01 14:29:48.395928
599	13	12	2024-08-01 14:29:49.7858	2024-08-01 14:29:53.611205
634	13	12	2024-08-01 15:15:22.346271	2024-08-01 15:15:22.530322
600	13	12	2024-08-01 14:29:54.201943	2024-08-01 14:29:58.897875
601	13	12	2024-08-01 14:29:59.49558	2024-08-01 14:29:59.66718
635	13	12	2024-08-01 15:15:23.570429	2024-08-01 15:15:27.59176
602	13	12	2024-08-01 14:30:00.702911	2024-08-01 14:30:05.020245
603	13	12	2024-08-01 14:30:05.644305	2024-08-01 14:30:11.880721
636	13	12	2024-08-01 15:15:28.189782	2024-08-01 15:15:34.61294
604	13	12	2024-08-01 14:30:12.479592	2024-08-01 14:30:18.837972
605	13	12	2024-08-01 14:34:40.088931	2024-08-01 14:34:40.686818
637	13	12	2024-08-01 15:15:35.22847	2024-08-01 15:15:42.04965
606	13	12	2024-08-01 14:34:46.054087	2024-08-01 14:34:46.637237
607	13	12	2024-08-01 14:34:47.368499	2024-08-01 14:34:53.65539
638	13	12	2024-08-19 10:21:24.861895	2024-08-19 10:21:25.743293
608	13	12	2024-08-01 14:34:55.410908	2024-08-01 14:34:58.402912
609	13	12	2024-08-01 14:35:00.382217	2024-08-01 14:35:06.123528
639	13	12	2024-08-19 10:21:50.146786	2024-08-19 10:21:50.98341
610	13	12	2024-08-01 14:35:07.91342	2024-08-01 14:35:11.548239
611	13	12	2024-08-01 14:35:13.322821	2024-08-01 14:35:18.301306
640	13	12	2024-08-19 10:21:55.660301	2024-08-19 10:24:53.324835
612	13	12	2024-08-01 14:35:19.046883	2024-08-01 14:35:25.057597
613	13	12	2024-08-01 14:35:25.787136	2024-08-01 14:35:25.992239
641	13	12	2024-08-19 10:24:54.278675	2024-08-19 10:25:05.606294
614	13	12	2024-08-01 14:35:27.272054	2024-08-01 14:35:32.210697
615	13	12	2024-08-01 14:35:32.907069	2024-08-01 14:35:41.006105
642	13	12	2024-08-19 10:25:08.111262	2024-08-19 10:25:12.224635
616	13	12	2024-08-01 14:35:41.879358	2024-08-01 14:39:52.271639
617	13	12	2024-08-01 14:39:52.863372	2024-08-01 14:39:59.547517
643	13	12	2024-08-19 10:25:14.680167	2024-08-19 10:25:22.096083
618	13	12	2024-08-01 14:40:00.901194	2024-08-01 14:40:03.542299
619	13	12	2024-08-01 14:40:04.958078	2024-08-01 14:40:09.228892
644	13	12	2024-08-19 10:25:24.490654	2024-08-19 10:25:29.082261
620	13	12	2024-08-01 14:40:10.544395	2024-08-01 14:40:13.213356
621	13	12	2024-08-01 14:40:14.573825	2024-08-01 14:40:18.296532
645	13	12	2024-08-19 10:25:31.527991	2024-08-19 10:25:38.210016
622	13	12	2024-08-01 14:40:18.858527	2024-08-01 14:40:23.361919
623	13	12	2024-08-01 14:40:23.924171	2024-08-01 14:40:24.08523
646	13	12	2024-08-19 10:25:39.102688	2024-08-19 10:25:47.318908
624	13	12	2024-08-01 14:40:24.995788	2024-08-01 14:40:28.674666
625	13	12	2024-08-01 14:40:29.262154	2024-08-01 14:40:35.123031
647	13	12	2024-08-19 10:25:48.243116	2024-08-19 10:25:48.530807
648	13	12	2024-08-19 10:25:50.297011	2024-08-19 10:25:57.04452
649	13	12	2024-08-19 10:25:57.931873	2024-08-19 10:26:09.075548
650	13	12	2024-08-19 10:26:09.969169	2024-08-19 10:26:36.544794
651	13	12	2024-08-19 10:28:19.052583	2024-08-19 10:28:19.485942
652	13	12	2024-08-19 10:28:24.016846	2024-08-19 10:28:24.44608
653	13	12	2024-08-19 10:28:25.015909	2024-08-19 10:28:29.60561
654	13	12	2024-08-19 10:28:30.918113	2024-08-19 10:28:33.130652
655	13	12	2024-08-19 10:28:34.475191	2024-08-19 10:28:38.539361
656	13	12	2024-08-19 10:28:39.818077	2024-08-19 10:28:42.41166
657	13	12	2024-08-19 10:28:43.743354	2024-08-19 10:28:47.388234
658	13	12	2024-08-19 10:28:47.950062	2024-08-19 10:28:52.39411
659	13	12	2024-08-19 10:28:52.969013	2024-08-19 10:28:53.141506
660	13	12	2024-08-19 10:28:54.044994	2024-08-19 10:28:57.657489
661	13	12	2024-08-19 10:28:58.215114	2024-08-19 10:29:04.128787
662	13	12	2024-08-19 10:29:04.664609	2024-08-20 09:54:43.735866
663	13	12	2024-08-20 09:54:49.087901	2024-08-20 09:54:49.671958
664	13	12	2024-08-20 09:54:50.361753	2024-08-20 09:54:56.50978
665	13	12	2024-08-20 09:54:58.272928	2024-08-20 09:55:01.229131
666	13	12	2024-08-20 09:55:03.069472	2024-08-20 09:55:08.54049
667	13	12	2024-08-20 09:55:10.381638	2024-08-20 09:55:13.82033
668	13	12	2024-08-20 09:55:15.713742	2024-08-20 09:55:20.532676
669	13	12	2024-08-20 09:55:21.266581	2024-08-20 09:55:27.284501
670	13	12	2024-08-20 09:55:27.979345	2024-08-20 09:55:28.179792
671	13	12	2024-08-20 09:55:29.403849	2024-08-20 09:55:34.24557
672	13	12	2024-08-20 09:55:34.916327	2024-08-20 09:55:42.777434
673	13	12	2024-08-20 09:55:43.479659	2024-08-20 15:08:58.316061
674	13	12	2024-08-20 15:09:03.065858	2024-08-20 15:09:03.464467
675	13	12	2024-08-20 15:09:04.002894	2024-08-20 15:09:08.044469
676	13	12	2024-08-20 15:09:09.167427	2024-08-20 15:09:11.146849
677	13	12	2024-08-20 15:09:12.317913	2024-08-20 15:09:15.767741
678	13	12	2024-08-20 15:09:16.880647	2024-08-20 15:09:19.102686
679	13	12	2024-08-20 15:09:20.240354	2024-08-20 15:09:23.331414
680	13	12	2024-08-20 15:09:23.815582	2024-08-20 15:09:27.651469
681	13	12	2024-08-20 15:09:28.154864	2024-08-20 15:09:28.284441
682	13	12	2024-08-20 15:09:29.155989	2024-08-20 15:09:32.375941
683	13	12	2024-08-20 15:09:32.861655	2024-08-20 15:09:37.789354
684	13	12	2024-08-20 15:09:38.290184	2024-08-28 13:54:22.193922
685	13	12	2024-08-28 13:54:26.741106	2024-08-28 13:54:27.231691
686	13	12	2024-08-28 13:54:27.805778	2024-08-28 13:54:32.780353
687	13	12	2024-08-28 13:54:34.112604	2024-08-28 13:54:36.608213
688	13	12	2024-08-28 13:54:37.984706	2024-08-28 13:54:42.107302
689	13	12	2024-08-28 13:54:43.437376	2024-08-28 13:54:46.133402
690	13	12	2024-08-28 13:54:47.484436	2024-08-28 13:54:51.232411
691	13	12	2024-08-28 13:54:51.812312	2024-08-28 13:54:56.415032
692	13	12	2024-08-28 13:54:56.993167	2024-08-28 13:54:57.210173
693	13	12	2024-08-28 13:54:58.110323	2024-08-28 13:55:02.163462
694	13	12	2024-08-28 13:55:02.841304	2024-08-28 13:55:08.912511
695	13	12	2024-08-28 13:55:09.512302	2024-08-28 17:04:17.449781
696	13	12	2024-08-28 17:04:22.424102	2024-08-28 17:04:22.910176
697	13	12	2024-08-28 17:04:23.550922	2024-08-28 17:04:28.675264
698	13	12	2024-08-28 17:04:30.117176	2024-08-28 17:04:32.723294
699	13	12	2024-08-28 17:04:34.206808	2024-08-28 17:04:38.702506
700	13	12	2024-08-28 17:04:40.11517	2024-08-28 17:04:43.16126
861	13	12	2024-09-19 18:38:33.098837	2024-09-19 18:38:39.563556
701	13	12	2024-08-28 17:04:44.591806	2024-08-28 17:04:48.650829
702	13	12	2024-08-28 17:04:49.241247	2024-08-28 17:04:54.230055
703	13	12	2024-08-28 17:04:54.87097	2024-08-28 17:04:55.04733
704	13	12	2024-08-28 17:04:56.036881	2024-08-28 17:05:00.055449
705	13	12	2024-08-28 17:05:00.696163	2024-08-28 17:05:07.358464
706	13	12	2024-08-28 17:05:07.991721	2024-09-02 14:29:38.34868
707	13	12	2024-09-02 14:29:44.972904	2024-09-02 14:29:45.913376
708	13	12	2024-09-02 14:29:46.803486	2024-09-02 14:29:54.538909
709	13	12	2024-09-02 14:29:56.600422	2024-09-02 14:29:59.849094
710	13	12	2024-09-02 14:30:01.749949	2024-09-02 14:30:07.817698
711	13	12	2024-09-02 14:30:09.459238	2024-09-02 14:30:12.938971
712	13	12	2024-09-02 14:30:14.699849	2024-09-02 14:30:19.506179
713	13	12	2024-09-02 14:30:20.232137	2024-09-02 14:30:25.767839
714	13	12	2024-09-02 14:30:26.471269	2024-09-02 14:30:26.740569
715	13	12	2024-09-02 14:30:27.879324	2024-09-02 14:30:32.427202
716	13	12	2024-09-02 14:30:33.071174	2024-09-02 14:30:40.214581
717	13	12	2024-09-02 14:30:40.905718	2024-09-04 19:34:13.991829
718	13	12	2024-09-04 19:34:18.325685	2024-09-04 19:34:18.744342
719	13	12	2024-09-04 19:34:19.328169	2024-09-04 19:34:23.708072
720	13	12	2024-09-04 19:34:24.906646	2024-09-04 19:34:27.205354
721	13	12	2024-09-04 19:34:28.478854	2024-09-04 19:34:32.536642
722	13	12	2024-09-04 19:34:33.74804	2024-09-04 19:34:36.353704
723	13	12	2024-09-04 19:34:37.579008	2024-09-04 19:34:41.151481
724	13	12	2024-09-04 19:34:41.73476	2024-09-04 19:34:46.282082
725	13	12	2024-09-04 19:34:46.876826	2024-09-04 19:34:47.072862
726	13	12	2024-09-04 19:34:47.920435	2024-09-04 19:34:51.44442
727	13	12	2024-09-04 19:34:52.011378	2024-09-04 19:34:57.494464
728	13	12	2024-09-04 19:34:58.010013	2024-09-04 20:03:52.388402
729	13	12	2024-09-04 20:03:56.644375	2024-09-04 20:03:57.108224
730	13	12	2024-09-04 20:03:57.64632	2024-09-04 20:04:02.350415
731	13	12	2024-09-04 20:04:03.599228	2024-09-04 20:04:05.850115
732	13	12	2024-09-04 20:04:07.062333	2024-09-04 20:04:10.850393
733	13	12	2024-09-04 20:04:12.103465	2024-09-04 20:04:14.769675
734	13	12	2024-09-04 20:04:15.998475	2024-09-04 20:04:19.499708
735	13	12	2024-09-04 20:04:20.08141	2024-09-04 20:04:24.305766
736	13	12	2024-09-04 20:04:24.817328	2024-09-04 20:04:25.001857
737	13	12	2024-09-04 20:04:25.81911	2024-09-04 20:04:29.313937
738	13	12	2024-09-04 20:04:29.852666	2024-09-04 20:04:35.268483
739	13	12	2024-09-04 20:04:35.802913	2024-09-08 11:46:37.082164
740	13	12	2024-09-08 11:46:42.550983	2024-09-08 11:46:43.237639
741	13	12	2024-09-08 11:46:43.983779	2024-09-08 11:46:50.674208
742	13	12	2024-09-08 11:46:52.440591	2024-09-08 11:46:55.594767
743	13	12	2024-09-08 11:46:57.38931	2024-09-08 11:47:03.252493
744	13	12	2024-09-08 11:47:05.048434	2024-09-08 11:47:08.743316
745	13	12	2024-09-08 11:47:10.54917	2024-09-08 11:47:15.621503
746	13	12	2024-09-08 11:47:16.373539	2024-09-08 11:47:22.936336
747	13	12	2024-09-08 11:47:23.639636	2024-09-08 11:47:23.868167
748	13	12	2024-09-08 11:47:25.155692	2024-09-08 11:47:30.218102
749	13	12	2024-09-08 11:47:30.959003	2024-09-08 11:47:39.151257
750	13	12	2024-09-08 11:47:39.868425	2024-09-08 12:03:05.322996
751	13	12	2024-09-08 12:03:09.909291	2024-09-08 12:03:10.345027
752	13	12	2024-09-08 12:03:10.873689	2024-09-08 12:03:15.337054
753	13	12	2024-09-08 12:03:16.476991	2024-09-08 12:03:18.554503
754	13	12	2024-09-08 12:03:19.75122	2024-09-08 12:03:23.563472
755	13	12	2024-09-08 12:03:24.723534	2024-09-08 12:03:27.201868
756	13	12	2024-09-08 12:03:28.393087	2024-09-08 12:03:31.731956
757	13	12	2024-09-08 12:03:32.250254	2024-09-08 12:03:36.406129
758	13	12	2024-09-08 12:03:36.930724	2024-09-08 12:03:37.10003
759	13	12	2024-09-08 12:03:37.959646	2024-09-08 12:03:41.664065
760	13	12	2024-09-08 12:03:42.200736	2024-09-08 12:03:47.984719
761	13	12	2024-09-08 12:03:48.525588	2024-09-08 12:07:23.045614
762	13	12	2024-09-08 12:07:31.151448	2024-09-08 12:07:32.138577
763	13	12	2024-09-08 12:07:32.994761	2024-09-08 12:07:40.379501
764	13	12	2024-09-08 12:07:41.974585	2024-09-08 12:07:45.367002
765	13	12	2024-09-08 12:07:46.878866	2024-09-08 12:07:52.002374
766	13	12	2024-09-08 12:07:53.40206	2024-09-08 12:07:56.336084
767	13	12	2024-09-08 12:07:57.792662	2024-09-08 12:08:01.826708
768	13	12	2024-09-08 12:08:02.497721	2024-09-08 12:08:07.419551
769	13	12	2024-09-08 12:08:08.049989	2024-09-08 12:08:08.319542
770	13	12	2024-09-08 12:08:09.222076	2024-09-08 12:08:13.294874
771	13	12	2024-09-08 12:08:13.890007	2024-09-08 12:08:20.020218
772	13	12	2024-09-08 12:08:20.580203	2024-09-08 12:21:20.727324
773	13	12	2024-09-08 12:21:26.703106	2024-09-08 12:21:27.400227
774	13	12	2024-09-08 12:21:28.227061	2024-09-08 12:21:34.958339
775	13	12	2024-09-08 12:21:36.823671	2024-09-08 12:21:40.234953
776	13	12	2024-09-08 12:21:42.163663	2024-09-08 12:21:48.695321
777	13	12	2024-09-08 12:21:50.530192	2024-09-08 12:21:54.276781
778	13	12	2024-09-08 12:21:56.194088	2024-09-08 12:22:01.4963
779	13	12	2024-09-08 12:22:02.280177	2024-09-08 12:22:08.669806
780	13	12	2024-09-08 12:22:09.39904	2024-09-08 12:22:09.641671
781	13	12	2024-09-08 12:22:10.941937	2024-09-08 12:22:16.261232
782	13	12	2024-09-08 12:22:16.991865	2024-09-08 12:22:25.384577
783	13	12	2024-09-08 12:22:26.14343	2024-09-15 17:04:59.472519
784	13	12	2024-09-15 17:05:04.490773	2024-09-15 17:05:04.991486
785	13	12	2024-09-15 17:05:05.597636	2024-09-15 17:05:10.095939
786	13	12	2024-09-15 17:05:11.269202	2024-09-15 17:05:13.426837
787	13	12	2024-09-15 17:05:14.684616	2024-09-15 17:05:18.424508
788	13	12	2024-09-15 17:05:19.580086	2024-09-15 17:05:22.024762
789	13	12	2024-09-15 17:05:23.221202	2024-09-15 17:05:26.597237
790	13	12	2024-09-15 17:05:27.14222	2024-09-15 17:05:31.274066
791	13	12	2024-09-15 17:05:31.763001	2024-09-15 17:05:31.916601
792	13	12	2024-09-15 17:05:32.715191	2024-09-15 17:05:36.009198
793	13	12	2024-09-15 17:05:36.524139	2024-09-15 17:05:41.619323
794	13	12	2024-09-15 17:05:42.114084	2024-09-18 20:09:30.791482
795	13	12	2024-09-18 20:09:35.949643	2024-09-18 20:09:36.541587
796	13	12	2024-09-18 20:09:37.20561	2024-09-18 20:09:42.620417
797	13	12	2024-09-18 20:09:44.086281	2024-09-18 20:09:46.948893
798	13	12	2024-09-18 20:09:48.461019	2024-09-18 20:09:53.199187
799	13	12	2024-09-18 20:09:54.641538	2024-09-18 20:09:57.703049
800	13	12	2024-09-18 20:09:59.218611	2024-09-18 20:10:03.864394
801	13	12	2024-09-18 20:10:04.566186	2024-09-18 20:10:10.006501
802	13	12	2024-09-18 20:10:10.642623	2024-09-18 20:10:10.862585
803	13	12	2024-09-18 20:10:11.924579	2024-09-18 20:10:16.209703
804	13	12	2024-09-18 20:10:16.852072	2024-09-18 20:10:23.692457
805	13	12	2024-09-18 20:10:24.300668	2024-09-18 20:11:02.582407
806	13	12	2024-09-18 20:11:06.993443	2024-09-18 20:11:07.45872
807	13	12	2024-09-18 20:11:08.03422	2024-09-18 20:11:12.505946
808	13	12	2024-09-18 20:11:13.739751	2024-09-18 20:11:16.002889
809	13	12	2024-09-18 20:11:17.220031	2024-09-18 20:11:21.090772
810	13	12	2024-09-18 20:11:22.268053	2024-09-18 20:11:24.771487
811	13	12	2024-09-18 20:11:26.004838	2024-09-18 20:11:29.456275
812	13	12	2024-09-18 20:11:30.022066	2024-09-18 20:11:34.150051
813	13	12	2024-09-18 20:11:34.658676	2024-09-18 20:11:34.823679
862	13	12	2024-09-19 18:38:40.794138	2024-09-19 18:38:43.197062
814	13	12	2024-09-18 20:11:35.59637	2024-09-18 20:11:39.05973
815	13	12	2024-09-18 20:11:39.572612	2024-09-18 20:11:45.008813
863	13	12	2024-09-19 18:38:44.432739	2024-09-19 18:38:48.139931
816	13	12	2024-09-18 20:11:45.522459	2024-09-18 20:32:24.722464
817	13	12	2024-09-18 20:32:25.496414	2024-09-18 20:32:34.31567
864	13	12	2024-09-19 18:38:49.307272	2024-09-19 18:38:51.763047
818	13	12	2024-09-18 20:32:36.139523	2024-09-18 20:32:39.216095
819	13	12	2024-09-18 20:32:41.061733	2024-09-18 20:32:47.057573
865	13	12	2024-09-19 18:38:52.96062	2024-09-19 18:38:56.310153
820	13	12	2024-09-18 20:32:48.883413	2024-09-18 20:32:52.475921
821	13	12	2024-09-18 20:32:54.307047	2024-09-18 20:32:59.415542
866	13	12	2024-09-19 18:38:56.814776	2024-09-19 18:39:01.054488
822	13	12	2024-09-18 20:33:00.178067	2024-09-18 20:33:06.402576
823	13	12	2024-09-18 20:33:07.194142	2024-09-18 20:33:07.486156
867	13	12	2024-09-19 18:39:01.691054	2024-09-19 18:39:01.896561
824	13	12	2024-09-18 20:33:08.761244	2024-09-18 20:33:13.918397
825	13	12	2024-09-18 20:33:14.780672	2024-09-18 20:33:22.824543
868	13	12	2024-09-19 18:39:02.822947	2024-09-19 18:39:06.31807
826	13	12	2024-09-18 20:33:23.570474	2024-09-18 20:33:32.357084
827	13	12	2024-09-19 17:58:38.255254	2024-09-19 17:58:38.76939
869	13	12	2024-09-19 18:39:06.876762	2024-09-19 18:39:12.153073
828	13	12	2024-09-19 17:58:39.449372	2024-09-19 17:58:46.246809
829	13	12	2024-09-19 17:58:47.591458	2024-09-19 17:58:49.965996
870	13	12	2024-09-19 18:39:12.762289	2024-09-19 18:39:18.342824
830	13	12	2024-09-19 17:58:57.105103	2024-09-19 17:59:01.501342
831	13	12	2024-09-19 17:59:02.93734	2024-09-19 17:59:06.258125
871	13	12	2024-09-20 11:45:14.959941	2024-09-20 11:45:15.501631
832	13	12	2024-09-19 17:59:07.723839	2024-09-19 17:59:11.835261
833	13	12	2024-09-19 17:59:12.437233	2024-09-19 17:59:17.395735
872	13	12	2024-09-20 11:45:16.065599	2024-09-20 11:45:22.225338
834	13	12	2024-09-19 17:59:17.994431	2024-09-19 17:59:18.173159
835	13	12	2024-09-19 17:59:19.136049	2024-09-19 17:59:23.106529
873	13	12	2024-09-20 11:45:23.447645	2024-09-20 11:45:25.652432
836	13	12	2024-09-19 17:59:23.704126	2024-09-19 17:59:29.98608
837	13	12	2024-09-19 17:59:30.739011	2024-09-19 17:59:38.325534
874	13	12	2024-09-20 11:45:26.842786	2024-09-20 11:45:30.801409
838	13	12	2024-09-19 18:22:05.665153	2024-09-19 18:22:06.301674
839	13	12	2024-09-19 18:22:07.096399	2024-09-19 18:22:15.006512
875	13	12	2024-09-20 11:45:31.959558	2024-09-20 11:45:34.432854
840	13	12	2024-09-19 18:22:16.733095	2024-09-19 18:22:19.813662
841	13	12	2024-09-19 18:22:21.678863	2024-09-19 18:22:27.232948
876	13	12	2024-09-20 11:45:35.602465	2024-09-20 11:45:39.055019
842	13	12	2024-09-19 18:22:28.948856	2024-09-19 18:22:32.671779
843	13	12	2024-09-19 18:22:34.451432	2024-09-19 18:22:39.427871
877	13	12	2024-09-20 11:45:39.613754	2024-09-20 11:45:43.696705
844	13	12	2024-09-19 18:22:40.134041	2024-09-19 18:22:46.203764
845	13	12	2024-09-19 18:22:46.932605	2024-09-19 18:22:47.14409
878	13	12	2024-09-20 11:45:44.197235	2024-09-20 11:45:44.355881
846	13	12	2024-09-19 18:22:48.349971	2024-09-19 18:22:53.226045
847	13	12	2024-09-19 18:22:53.935964	2024-09-19 18:23:02.486537
879	13	12	2024-09-20 11:45:45.152553	2024-09-20 11:45:48.465195
848	13	12	2024-09-19 18:23:03.268704	2024-09-19 18:23:11.755442
849	13	12	2024-09-19 18:35:19.606479	2024-09-19 18:35:20.189525
880	13	12	2024-09-20 11:45:48.998752	2024-09-20 11:45:54.129472
850	13	12	2024-09-19 18:35:20.901749	2024-09-19 18:35:28.97344
851	13	12	2024-09-19 18:35:30.742768	2024-09-19 18:35:34.127577
881	13	12	2024-09-20 11:45:54.622019	2024-09-20 11:45:59.979011
852	13	12	2024-09-19 18:35:35.917589	2024-09-19 18:35:41.351458
853	13	12	2024-09-19 18:35:43.047999	2024-09-19 18:35:46.44753
882	13	12	2024-09-22 13:09:35.193795	2024-09-22 13:09:35.649375
854	13	12	2024-09-19 18:35:48.177141	2024-09-19 18:35:53.005593
855	13	12	2024-09-19 18:35:53.716235	2024-09-19 18:35:59.604468
883	13	12	2024-09-22 13:09:36.211043	2024-09-22 13:09:42.406261
856	13	12	2024-09-19 18:36:00.407285	2024-09-19 18:36:00.634369
857	13	12	2024-09-19 18:36:01.846752	2024-09-19 18:36:06.719121
884	13	12	2024-09-22 13:09:43.560442	2024-09-22 13:09:45.67733
858	13	12	2024-09-19 18:36:07.453361	2024-09-19 18:36:15.041671
859	13	12	2024-09-19 18:36:15.759554	2024-09-19 18:36:23.828797
885	13	12	2024-09-22 13:09:46.940684	2024-09-22 13:09:50.731136
886	13	12	2024-09-22 13:09:51.876476	2024-09-22 13:09:54.289861
887	13	12	2024-09-22 13:09:55.552694	2024-09-22 13:09:58.88718
888	13	12	2024-09-22 13:09:59.412751	2024-09-22 13:10:04.16826
889	13	12	2024-09-22 13:10:04.764077	2024-09-22 13:10:04.976814
890	13	12	2024-09-22 13:10:05.81552	2024-09-22 13:10:09.244233
891	13	12	2024-09-22 13:10:09.794395	2024-09-22 13:10:14.996942
892	13	12	2024-09-22 13:10:15.512055	2024-09-22 13:10:20.966139
893	13	12	2024-10-07 15:34:27.274741	2024-10-07 15:34:27.69191
894	13	12	2024-10-07 15:34:28.195503	2024-10-07 15:34:34.434577
895	13	12	2024-10-07 15:34:35.558424	2024-10-07 15:34:37.638061
896	13	12	2024-10-07 15:34:38.791834	2024-10-07 15:34:42.406432
897	13	12	2024-10-07 15:34:43.529726	2024-10-07 15:34:45.883978
898	13	12	2024-10-07 15:34:47.014889	2024-10-07 15:34:50.171066
899	13	12	2024-10-07 15:34:50.684197	2024-10-07 15:34:54.492237
900	13	12	2024-10-07 15:34:54.970887	2024-10-07 15:34:55.109649
901	13	12	2024-10-07 15:34:55.85088	2024-10-07 15:34:59.117251
902	13	12	2024-10-07 15:34:59.601883	2024-10-07 15:35:05.174248
903	13	12	2024-10-07 15:35:05.778815	2024-10-07 15:35:11.121143
904	13	12	2024-10-11 09:29:33.328456	2024-10-11 09:29:33.96969
905	13	12	2024-10-11 09:29:39.254726	2024-10-11 09:29:39.856172
906	13	12	2024-10-11 09:29:40.564851	2024-10-11 09:29:46.699348
907	13	12	2024-10-11 09:29:48.389957	2024-10-11 09:29:51.315989
908	13	12	2024-10-11 09:29:53.090272	2024-10-11 09:29:58.4941
909	13	12	2024-10-11 09:30:00.198075	2024-10-11 09:30:04.326191
910	13	12	2024-10-11 09:30:06.18354	2024-10-11 09:30:11.195312
911	13	12	2024-10-11 09:30:11.906885	2024-10-11 09:30:17.891366
912	13	12	2024-10-11 09:30:18.595502	2024-10-11 09:30:18.818641
913	13	12	2024-10-11 09:30:20.040892	2024-10-11 09:30:24.983151
914	13	12	2024-10-11 09:30:25.664826	2024-10-11 09:30:33.547181
915	13	12	2024-10-11 09:30:34.26135	2024-10-14 13:15:43.118729
916	13	12	2024-10-14 13:15:48.873074	2024-10-14 13:15:49.493311
917	13	12	2024-10-14 13:15:50.228197	2024-10-14 13:15:56.568702
918	13	12	2024-10-14 13:15:58.353663	2024-10-14 13:16:01.460194
919	13	12	2024-10-14 13:16:03.376603	2024-10-14 13:16:09.07888
920	13	12	2024-10-14 13:16:10.86777	2024-10-14 13:16:14.462016
921	13	12	2024-10-14 13:16:16.25566	2024-10-14 13:16:21.320732
922	13	12	2024-10-14 13:16:22.202915	2024-10-14 13:16:28.306085
923	13	12	2024-10-14 13:16:29.065954	2024-10-14 13:16:29.292708
924	13	12	2024-10-14 13:16:30.53743	2024-10-14 13:16:35.585289
925	13	12	2024-10-14 13:16:36.3954	2024-10-14 13:16:44.517772
926	13	12	2024-10-14 13:16:45.249618	2024-10-14 13:56:58.90662
927	13	12	2024-10-14 13:57:03.472434	2024-10-14 13:57:03.920319
928	13	12	2024-10-14 13:57:04.484012	2024-10-14 13:57:08.687587
929	13	12	2024-10-14 13:57:09.869099	2024-10-14 13:57:12.027753
930	13	12	2024-10-14 13:57:13.250084	2024-10-14 13:57:16.945884
931	13	12	2024-10-14 13:57:18.112627	2024-10-14 13:57:20.744566
932	13	12	2024-10-14 13:57:21.975115	2024-10-14 13:57:25.357463
933	13	12	2024-10-14 13:57:25.898938	2024-10-14 13:57:30.039049
934	13	12	2024-10-14 13:57:30.593347	2024-10-14 13:57:30.772053
935	13	12	2024-10-14 13:57:31.549285	2024-10-14 13:57:34.854241
936	13	12	2024-10-14 13:57:35.374289	2024-10-14 13:57:40.590742
937	13	12	2024-10-14 13:57:41.096025	2024-10-14 13:59:12.730167
938	13	12	2024-10-14 13:59:17.144616	2024-10-14 13:59:17.615681
939	13	12	2024-10-14 13:59:18.152947	2024-10-14 13:59:22.379565
940	13	12	2024-10-14 13:59:23.544348	2024-10-14 13:59:25.696798
941	13	12	2024-10-14 13:59:26.920881	2024-10-14 13:59:30.537956
942	13	12	2024-10-14 13:59:31.648384	2024-10-14 13:59:34.054638
943	13	12	2024-10-14 13:59:35.191149	2024-10-14 13:59:38.48573
944	13	12	2024-10-14 13:59:38.991674	2024-10-14 13:59:42.98131
945	13	12	2024-10-14 13:59:43.510513	2024-10-14 13:59:43.681616
946	13	12	2024-10-14 13:59:44.464684	2024-10-14 13:59:47.697771
947	13	12	2024-10-14 13:59:48.216255	2024-10-14 13:59:53.428365
948	13	12	2024-10-14 13:59:54.008722	2024-10-17 17:30:00.081256
949	13	12	2024-10-17 17:30:01.118877	2024-10-17 17:30:09.208582
950	13	12	2024-10-17 17:30:10.67431	2024-10-17 17:30:13.892765
951	13	12	2024-10-17 17:30:15.34726	2024-10-17 17:30:20.081309
952	13	12	2024-10-17 17:30:21.285632	2024-10-17 17:30:24.154411
953	13	12	2024-10-17 17:30:25.453371	2024-10-17 17:30:29.292559
954	13	12	2024-10-17 17:30:29.87457	2024-10-17 17:30:34.35263
955	13	12	2024-10-17 17:30:34.934165	2024-10-17 17:30:35.127978
956	13	12	2024-10-17 17:30:35.940858	2024-10-17 17:30:39.582371
957	13	12	2024-10-17 17:30:40.133351	2024-10-17 17:30:45.72521
958	13	12	2024-10-17 17:30:46.302457	2024-10-17 17:30:51.990613
959	13	12	2024-10-17 17:31:04.816897	2024-10-17 17:31:05.487741
960	13	12	2024-10-17 17:31:11.567002	2024-10-17 17:31:12.215168
961	13	12	2024-10-17 17:31:12.978384	2024-10-17 17:31:19.686169
962	13	12	2024-10-17 17:31:21.507339	2024-10-17 17:31:24.712093
963	13	12	2024-10-17 17:31:26.58717	2024-10-17 17:31:32.588153
964	13	12	2024-10-17 17:31:34.372368	2024-10-17 17:31:38.179939
965	13	12	2024-10-17 17:31:40.078169	2024-10-17 17:31:45.311865
966	13	12	2024-10-17 17:31:46.072077	2024-10-17 17:31:52.424538
967	13	12	2024-10-17 17:31:53.175858	2024-10-17 17:31:53.42345
968	13	12	2024-10-17 17:31:54.749428	2024-10-17 17:32:00.124928
969	13	12	2024-10-17 17:32:00.89904	2024-10-17 17:32:09.37946
970	13	12	2024-10-17 17:32:10.138008	2024-10-22 12:24:03.708416
971	13	12	2024-10-22 12:24:08.164371	2024-10-22 12:24:08.644085
972	13	12	2024-10-22 12:24:09.201105	2024-10-22 12:24:13.708645
973	13	12	2024-10-22 12:24:14.928119	2024-10-22 12:24:17.17942
974	13	12	2024-10-22 12:24:18.391383	2024-10-22 12:24:22.294212
975	13	12	2024-10-22 12:24:23.472984	2024-10-22 12:24:26.116339
976	13	12	2024-10-22 12:24:27.318007	2024-10-22 12:24:30.88348
977	13	12	2024-10-22 12:24:31.412232	2024-10-22 12:24:35.4742
978	13	12	2024-10-22 12:24:35.980087	2024-10-22 12:24:36.223039
979	13	12	2024-10-22 12:24:37.006666	2024-10-22 12:24:40.375685
980	13	12	2024-10-22 12:24:40.913859	2024-10-22 12:24:46.175015
981	13	12	2024-10-22 12:24:46.680228	2024-10-22 12:43:27.779174
982	13	12	2024-10-22 12:43:32.517434	2024-10-22 12:43:32.980445
983	13	12	2024-10-22 12:43:33.509052	2024-10-22 12:43:37.761317
984	13	12	2024-10-22 12:43:38.92061	2024-10-22 12:43:41.06326
985	13	12	2024-10-22 12:43:42.281884	2024-10-22 12:43:45.998544
986	13	12	2024-10-22 12:43:47.149914	2024-10-22 12:43:49.586588
987	13	12	2024-10-22 12:43:50.771911	2024-10-22 12:43:54.130796
988	13	12	2024-10-22 12:43:54.650086	2024-10-22 12:43:58.816564
989	13	12	2024-10-22 12:43:59.337008	2024-10-22 12:43:59.526821
990	13	12	2024-10-22 12:44:00.338914	2024-10-22 12:44:04.039877
991	13	12	2024-10-22 12:44:04.57156	2024-10-22 12:44:09.92154
992	13	12	2024-10-22 12:44:10.448021	2024-10-22 13:10:19.631138
993	13	12	2024-10-22 13:10:23.957185	2024-10-22 13:10:24.396031
994	13	12	2024-10-22 13:10:24.951363	2024-10-22 13:10:29.310582
995	13	12	2024-10-22 13:10:30.501683	2024-10-22 13:10:32.654616
996	13	12	2024-10-22 13:10:33.859443	2024-10-22 13:10:37.667124
997	13	12	2024-10-22 13:10:38.827639	2024-10-22 13:10:41.334452
998	13	12	2024-10-22 13:10:42.718341	2024-10-22 13:10:46.304527
999	13	12	2024-10-22 13:10:46.854087	2024-10-22 13:10:51.058953
1000	13	12	2024-10-22 13:10:51.609456	2024-10-22 13:10:51.877571
1001	13	12	2024-10-22 13:10:52.682756	2024-10-22 13:10:56.340569
1002	13	12	2024-10-22 13:10:56.91983	2024-10-22 13:11:02.487691
1003	13	12	2024-10-22 13:11:03.059403	2024-10-22 13:15:53.47714
1004	13	12	2024-10-22 13:15:58.911027	2024-10-22 13:15:59.541612
1005	13	12	2024-10-22 13:16:00.348136	2024-10-22 13:16:06.793422
1006	13	12	2024-10-22 13:16:08.602988	2024-10-22 13:16:11.720641
1007	13	12	2024-10-22 13:16:13.539904	2024-10-22 13:16:19.120902
1008	13	12	2024-10-22 13:16:20.909575	2024-10-22 13:16:24.582649
1009	13	12	2024-10-22 13:16:26.404478	2024-10-22 13:16:31.432625
1010	13	12	2024-10-22 13:16:32.146025	2024-10-22 13:16:38.174076
1011	13	12	2024-10-22 13:16:38.890317	2024-10-22 13:16:39.117691
1012	13	12	2024-10-22 13:16:40.35721	2024-10-22 13:16:45.364078
1013	13	12	2024-10-22 13:16:46.09726	2024-10-22 13:16:54.21277
1014	13	12	2024-10-22 13:16:54.900441	2024-10-22 13:18:14.776831
1015	13	12	2024-10-22 13:18:19.468563	2024-10-22 13:18:19.964552
1016	13	12	2024-10-22 13:18:20.539954	2024-10-22 13:18:25.313774
1017	13	12	2024-10-22 13:18:26.654993	2024-10-22 13:18:29.188499
1018	13	12	2024-10-22 13:18:30.553855	2024-10-22 13:18:34.781367
1019	13	12	2024-10-22 13:18:36.079209	2024-10-22 13:18:38.767428
1020	13	12	2024-10-22 13:18:40.087351	2024-10-22 13:18:43.88833
1021	13	12	2024-10-22 13:18:44.439402	2024-10-22 13:18:48.976111
1022	13	12	2024-10-22 13:18:49.537752	2024-10-22 13:18:49.70653
1023	13	12	2024-10-22 13:18:50.587929	2024-10-22 13:18:54.309658
1024	13	12	2024-10-22 13:18:54.865661	2024-10-22 13:19:00.786049
1025	13	12	2024-10-22 13:19:01.375757	2024-10-22 13:22:35.867611
1026	13	12	2024-10-22 13:22:41.347843	2024-10-22 13:22:41.980432
1027	13	12	2024-10-22 13:22:42.749545	2024-10-22 13:22:49.027991
1028	13	12	2024-10-22 13:22:50.780284	2024-10-22 13:22:53.827503
1029	13	12	2024-10-22 13:22:55.641586	2024-10-22 13:23:01.263839
1030	13	12	2024-10-22 13:23:03.142207	2024-10-22 13:23:06.682443
1031	13	12	2024-10-22 13:23:08.480272	2024-10-22 13:23:13.612367
1032	13	12	2024-10-22 13:23:14.363013	2024-10-22 13:23:20.535852
1033	13	12	2024-10-22 13:23:21.250103	2024-10-22 13:23:21.482587
1034	13	12	2024-10-22 13:23:22.739127	2024-10-22 13:23:27.727507
1035	13	12	2024-10-22 13:23:28.448542	2024-10-22 13:23:36.507688
1036	13	12	2024-10-22 13:23:37.219807	2024-10-22 18:34:56.820482
1037	13	12	2024-10-22 18:35:01.750462	2024-10-22 18:35:02.262559
1038	13	12	2024-10-22 18:35:02.84672	2024-10-22 18:35:07.453594
1039	13	12	2024-10-22 18:35:08.643446	2024-10-22 18:35:11.057914
1040	13	12	2024-10-22 18:35:12.285434	2024-10-22 18:35:16.135546
1041	13	12	2024-10-22 18:35:17.298237	2024-10-22 18:35:19.830076
1042	13	12	2024-10-22 18:35:21.031884	2024-10-22 18:35:24.431722
1043	13	12	2024-10-22 18:35:24.964787	2024-10-22 18:35:29.067502
1044	13	12	2024-10-22 18:35:29.615896	2024-10-22 18:35:29.779536
1045	13	12	2024-10-22 18:35:30.621529	2024-10-22 18:35:34.130636
1046	13	12	2024-10-22 18:35:34.660859	2024-10-22 18:35:39.937501
1047	13	12	2024-10-22 18:35:40.446998	2024-10-22 18:36:52.175924
1048	13	12	2024-10-22 18:36:57.536662	2024-10-22 18:36:58.204978
1049	13	12	2024-10-22 18:36:58.931434	2024-10-22 18:37:05.583562
1050	13	12	2024-10-22 18:37:07.440017	2024-10-22 18:37:10.646249
1051	13	12	2024-10-22 18:37:12.453627	2024-10-22 18:37:18.211919
1052	13	12	2024-10-22 18:37:19.993246	2024-10-22 18:37:23.757319
1053	13	12	2024-10-22 18:37:25.552986	2024-10-22 18:37:30.912156
1054	13	12	2024-10-22 18:37:31.631215	2024-10-22 18:37:37.751293
1055	13	12	2024-10-22 18:37:38.461502	2024-10-22 18:37:38.686537
1056	13	12	2024-10-22 18:37:39.947111	2024-10-22 18:37:44.98735
1057	13	12	2024-10-22 18:37:45.70298	2024-10-22 18:37:53.755192
1058	13	12	2024-10-22 18:37:54.464573	2024-10-22 18:38:35.63679
1059	13	12	2024-10-22 18:38:39.860826	2024-10-22 18:38:40.403512
1060	13	12	2024-10-22 18:38:40.89332	2024-10-22 18:38:45.052259
1061	13	12	2024-10-22 18:38:46.218308	2024-10-22 18:38:48.64685
1062	13	12	2024-10-22 18:38:49.836114	2024-10-22 18:38:53.533663
1063	13	12	2024-10-22 18:38:54.727713	2024-10-22 18:38:57.169903
1064	13	12	2024-10-22 18:38:58.326794	2024-10-22 18:39:01.940668
1065	13	12	2024-10-22 18:39:02.519946	2024-10-22 18:39:06.735673
1066	13	12	2024-10-22 18:39:07.253974	2024-10-22 18:39:07.42799
1067	13	12	2024-10-22 18:39:08.16986	2024-10-22 18:39:11.442904
1068	13	12	2024-10-22 18:39:11.940654	2024-10-22 18:39:17.129888
1069	13	12	2024-10-22 18:39:17.635775	2024-10-27 12:06:21.659343
1070	13	12	2024-10-27 12:06:27.084372	2024-10-27 12:06:28.255103
1071	13	12	2024-10-27 12:06:28.984137	2024-10-27 12:06:35.418213
1072	13	12	2024-10-27 12:06:37.175809	2024-10-27 12:06:40.227974
1073	13	12	2024-10-27 12:06:42.005416	2024-10-27 12:06:47.458306
1074	13	12	2024-10-27 12:06:49.188311	2024-10-27 12:06:52.746558
1075	13	12	2024-10-27 12:06:54.494445	2024-10-27 12:06:59.404764
1076	13	12	2024-10-27 12:07:00.107085	2024-10-27 12:07:06.193703
1077	13	12	2024-10-27 12:07:06.908996	2024-10-27 12:07:07.122944
1078	13	12	2024-10-27 12:07:08.3338	2024-10-27 12:07:13.260941
1079	13	12	2024-10-27 12:07:13.956341	2024-10-27 12:07:21.979903
1080	13	12	2024-10-27 12:07:22.775796	2024-10-27 12:21:36.463088
1081	13	12	2024-10-27 12:21:40.925624	2024-10-27 12:21:41.386051
1082	13	12	2024-10-27 12:21:41.938436	2024-10-27 12:21:46.635993
1083	13	12	2024-10-27 12:21:47.901842	2024-10-27 12:21:50.217109
1084	13	12	2024-10-27 12:21:51.529844	2024-10-27 12:21:55.649995
1085	13	12	2024-10-27 12:21:56.922831	2024-10-27 12:21:59.536098
1086	13	12	2024-10-27 12:22:00.869532	2024-10-27 12:22:04.580433
1087	13	12	2024-10-27 12:22:05.137128	2024-10-27 12:22:09.627603
1088	13	12	2024-10-27 12:22:10.184163	2024-10-27 12:22:10.337875
1089	13	12	2024-10-27 12:22:11.218967	2024-10-27 12:22:14.90351
1090	13	12	2024-10-27 12:22:15.459845	2024-10-27 12:22:21.262585
1091	13	12	2024-10-27 12:22:21.793935	2024-10-29 12:09:39.406662
1092	13	12	2024-10-29 12:09:44.931075	2024-10-29 12:09:45.575425
1093	13	12	2024-10-29 12:09:46.31107	2024-10-29 12:09:52.516011
1094	13	12	2024-10-29 12:09:54.289331	2024-10-29 12:09:57.40068
1095	13	12	2024-10-29 12:09:59.197787	2024-10-29 12:10:05.578231
1096	13	12	2024-10-29 12:10:07.388403	2024-10-29 12:10:11.041475
1097	13	12	2024-10-29 12:10:12.889091	2024-10-29 12:10:17.974946
1098	13	12	2024-10-29 12:10:18.706745	2024-10-29 12:10:24.829715
1099	13	12	2024-10-29 12:10:25.556488	2024-10-29 12:10:25.787165
1100	13	12	2024-10-29 12:10:27.050788	2024-10-29 12:10:32.091173
1101	13	12	2024-10-29 12:10:32.817934	2024-10-29 12:10:40.893708
1102	13	12	2024-10-29 12:10:41.60814	2024-10-30 18:22:13.696923
1103	13	12	2024-10-30 18:22:18.020428	2024-10-30 18:22:18.470664
1104	13	12	2024-10-30 18:22:19.021284	2024-10-30 18:22:23.195225
1105	13	12	2024-10-30 18:22:24.330512	2024-10-30 18:22:26.55061
1106	13	12	2024-10-30 18:22:27.716552	2024-10-30 18:22:31.433881
1107	13	12	2024-10-30 18:22:32.547729	2024-10-30 18:22:34.949513
1108	13	12	2024-10-30 18:22:36.096203	2024-10-30 18:22:39.378325
1109	13	12	2024-10-30 18:22:39.869458	2024-10-30 18:22:43.827702
1110	13	12	2024-10-30 18:22:44.325555	2024-10-30 18:22:44.497717
1111	13	12	2024-10-30 18:22:45.242329	2024-10-30 18:22:48.418542
1112	13	12	2024-10-30 18:22:48.907248	2024-10-30 18:22:53.967309
1113	13	12	2024-10-30 18:22:54.488735	\N
1114	11	27	2025-02-11 18:27:24.172527	\N
1115	11	28	2025-02-11 18:27:26.573186	\N
1116	11	29	2025-02-11 18:27:28.544873	\N
1117	11	30	2025-02-11 18:27:31.004787	\N
1118	11	31	2025-02-11 18:27:33.671883	2025-02-11 18:27:44.917208
1119	11	31	2025-02-21 03:56:12.71148	2025-02-21 03:56:14.372256
\.


--
-- Name: t_call_waiter_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_call_waiter_id_seq', 335, true);


--
-- Name: t_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_category_id_seq', 78, true);


--
-- Name: t_client_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_client_id_seq', 4, true);


--
-- Name: t_control_panel_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_control_panel_user_id_seq', 53, true);


--
-- Name: t_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_meal_id_seq', 740, true);


--
-- Name: t_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_order_id_seq', 1037, true);


--
-- Name: t_order_meal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_order_meal_id_seq', 1603, true);


--
-- Name: t_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_payment_id_seq', 994, true);


--
-- Name: t_restaurant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_restaurant_id_seq', 6, true);


--
-- Name: t_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_table_id_seq', 51, true);


--
-- Name: t_table_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_table_session_id_seq', 2150, true);


--
-- Name: t_user_table_id_seq; Type: SEQUENCE SET; Schema: public; Owner: doadmin
--

SELECT pg_catalog.setval('public.t_user_table_id_seq', 1119, true);


--
-- Name: flyway_schema_history flyway_schema_history_pk; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.flyway_schema_history
    ADD CONSTRAINT flyway_schema_history_pk PRIMARY KEY (installed_rank);


--
-- Name: t_call_waiter t_call_waiter_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_call_waiter
    ADD CONSTRAINT t_call_waiter_pkey PRIMARY KEY (id);


--
-- Name: t_category_localization t_category_details_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category_localization
    ADD CONSTRAINT t_category_details_pkey PRIMARY KEY (category_id, localization);


--
-- Name: t_category t_category_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category
    ADD CONSTRAINT t_category_pkey PRIMARY KEY (id);


--
-- Name: t_category t_category_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category
    ADD CONSTRAINT t_category_uuid_key UNIQUE (uuid);


--
-- Name: t_client t_client_email_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client
    ADD CONSTRAINT t_client_email_key UNIQUE (email);


--
-- Name: t_client t_client_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client
    ADD CONSTRAINT t_client_pkey PRIMARY KEY (id);


--
-- Name: t_client_secondary_language t_client_secondary_language_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client_secondary_language
    ADD CONSTRAINT t_client_secondary_language_pkey PRIMARY KEY (client_id, localization);


--
-- Name: t_client t_client_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client
    ADD CONSTRAINT t_client_uuid_key UNIQUE (uuid);


--
-- Name: t_user t_control_panel_user_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_control_panel_user_pkey PRIMARY KEY (id);


--
-- Name: t_user t_control_panel_user_username_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_control_panel_user_username_key UNIQUE (username);


--
-- Name: t_item_localization t_meal_details_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item_localization
    ADD CONSTRAINT t_meal_details_pkey PRIMARY KEY (item_id, localization);


--
-- Name: t_item t_meal_meal_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item
    ADD CONSTRAINT t_meal_meal_uuid_key UNIQUE (uuid);


--
-- Name: t_item t_meal_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item
    ADD CONSTRAINT t_meal_pkey PRIMARY KEY (id);


--
-- Name: t_order_item t_order_meal_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order_item
    ADD CONSTRAINT t_order_meal_pkey PRIMARY KEY (id);


--
-- Name: t_order t_order_order_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order
    ADD CONSTRAINT t_order_order_uuid_key UNIQUE (uuid);


--
-- Name: t_order t_order_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order
    ADD CONSTRAINT t_order_pkey PRIMARY KEY (id);


--
-- Name: t_payment t_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_payment
    ADD CONSTRAINT t_payment_pkey PRIMARY KEY (id);


--
-- Name: t_branch_item t_restaurant_meal_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch_item
    ADD CONSTRAINT t_restaurant_meal_pkey PRIMARY KEY (branch_id, item_id);


--
-- Name: t_branch t_restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch
    ADD CONSTRAINT t_restaurant_pkey PRIMARY KEY (id);


--
-- Name: t_branch t_restaurant_restaurant_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch
    ADD CONSTRAINT t_restaurant_restaurant_uuid_key UNIQUE (uuid);


--
-- Name: t_user t_staff_user_user_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_staff_user_user_uuid_key UNIQUE (uuid);


--
-- Name: t_table t_table_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table
    ADD CONSTRAINT t_table_pkey PRIMARY KEY (id);


--
-- Name: t_table_session t_table_session_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table_session
    ADD CONSTRAINT t_table_session_pkey PRIMARY KEY (id);


--
-- Name: t_table_session t_table_session_table_session_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table_session
    ADD CONSTRAINT t_table_session_table_session_uuid_key UNIQUE (table_session_uuid);


--
-- Name: t_table t_table_table_uuid_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table
    ADD CONSTRAINT t_table_table_uuid_key UNIQUE (uuid);


--
-- Name: t_user_branch t_user_branch_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_branch
    ADD CONSTRAINT t_user_branch_pkey PRIMARY KEY (user_id, branch_id);


--
-- Name: t_user t_user_email_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_user_email_key UNIQUE (email);


--
-- Name: t_user_table t_user_table_pkey; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_table
    ADD CONSTRAINT t_user_table_pkey PRIMARY KEY (id);


--
-- Name: t_category uq_t_category_client_sequence; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category
    ADD CONSTRAINT uq_t_category_client_sequence EXCLUDE USING gist (sequence WITH =, client_id WITH =) WHERE ((deleted_at IS NULL)) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: t_client uq_t_client_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client
    ADD CONSTRAINT uq_t_client_key UNIQUE (key);


--
-- Name: t_item uq_t_item_category_sequence; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item
    ADD CONSTRAINT uq_t_item_category_sequence EXCLUDE USING gist (sequence WITH =, category_id WITH =) WHERE ((deleted_at IS NULL)) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: t_user_table user_table_user_id_table_id_deleted_at_key; Type: CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_table
    ADD CONSTRAINT user_table_user_id_table_id_deleted_at_key UNIQUE (user_id, table_id, stopped_watching_at);


--
-- Name: flyway_schema_history_s_idx; Type: INDEX; Schema: public; Owner: doadmin
--

CREATE INDEX flyway_schema_history_s_idx ON public.flyway_schema_history USING btree (success);


--
-- Name: t_branch_item fk_branch_item_branch_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch_item
    ADD CONSTRAINT fk_branch_item_branch_id FOREIGN KEY (branch_id) REFERENCES public.t_branch(id);


--
-- Name: t_branch_item fk_branch_item_item_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch_item
    ADD CONSTRAINT fk_branch_item_item_id FOREIGN KEY (item_id) REFERENCES public.t_item(id);


--
-- Name: t_call_waiter fk_call_waiter_acknowledged_by; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_call_waiter
    ADD CONSTRAINT fk_call_waiter_acknowledged_by FOREIGN KEY (acknowledged_by) REFERENCES public.t_user(id);


--
-- Name: t_call_waiter fk_call_waiter_table_session_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_call_waiter
    ADD CONSTRAINT fk_call_waiter_table_session_id FOREIGN KEY (table_session_id) REFERENCES public.t_table_session(id);


--
-- Name: t_client_secondary_language fk_client_secondary_language_client_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_client_secondary_language
    ADD CONSTRAINT fk_client_secondary_language_client_id FOREIGN KEY (client_id) REFERENCES public.t_client(id);


--
-- Name: t_item_localization fk_item_localization_item_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item_localization
    ADD CONSTRAINT fk_item_localization_item_id FOREIGN KEY (item_id) REFERENCES public.t_item(id);


--
-- Name: t_item fk_meal_category_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_item
    ADD CONSTRAINT fk_meal_category_id FOREIGN KEY (category_id) REFERENCES public.t_category(id);


--
-- Name: t_category_localization fk_meal_details_meal_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category_localization
    ADD CONSTRAINT fk_meal_details_meal_id FOREIGN KEY (category_id) REFERENCES public.t_category(id);


--
-- Name: t_order_item fk_order_item_item_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order_item
    ADD CONSTRAINT fk_order_item_item_id FOREIGN KEY (item_id) REFERENCES public.t_item(id);


--
-- Name: t_order_item fk_order_meal_order_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order_item
    ADD CONSTRAINT fk_order_meal_order_id FOREIGN KEY (order_id) REFERENCES public.t_order(id);


--
-- Name: t_order fk_order_table_session_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order
    ADD CONSTRAINT fk_order_table_session_id FOREIGN KEY (table_session_id) REFERENCES public.t_table_session(id);


--
-- Name: t_order fk_order_user_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_order
    ADD CONSTRAINT fk_order_user_id FOREIGN KEY (status_changed_by) REFERENCES public.t_user(id);


--
-- Name: t_payment fk_payment_acknowledged_by; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_payment
    ADD CONSTRAINT fk_payment_acknowledged_by FOREIGN KEY (acknowledged_by) REFERENCES public.t_user(id);


--
-- Name: t_payment fk_payment_table_session_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_payment
    ADD CONSTRAINT fk_payment_table_session_id FOREIGN KEY (table_session_id) REFERENCES public.t_table_session(id);


--
-- Name: t_table fk_table_branch_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table
    ADD CONSTRAINT fk_table_branch_id FOREIGN KEY (branch_id) REFERENCES public.t_branch(id);


--
-- Name: t_table_session fk_table_session_table_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_table_session
    ADD CONSTRAINT fk_table_session_table_id FOREIGN KEY (table_id) REFERENCES public.t_table(id);


--
-- Name: t_user_branch fk_user_branch_branch_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_branch
    ADD CONSTRAINT fk_user_branch_branch_id FOREIGN KEY (branch_id) REFERENCES public.t_branch(id);


--
-- Name: t_user_branch fk_user_branch_user_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_branch
    ADD CONSTRAINT fk_user_branch_user_id FOREIGN KEY (user_id) REFERENCES public.t_user(id);


--
-- Name: t_user_table fk_user_table_table_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_table
    ADD CONSTRAINT fk_user_table_table_id FOREIGN KEY (table_id) REFERENCES public.t_table(id);


--
-- Name: t_user_table fk_user_table_user_id; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user_table
    ADD CONSTRAINT fk_user_table_user_id FOREIGN KEY (user_id) REFERENCES public.t_user(id);


--
-- Name: t_category t_category_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_category
    ADD CONSTRAINT t_category_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.t_client(id);


--
-- Name: t_user t_control_panel_user_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_user
    ADD CONSTRAINT t_control_panel_user_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.t_client(id);


--
-- Name: t_branch t_restaurant_client_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: doadmin
--

ALTER TABLE ONLY public.t_branch
    ADD CONSTRAINT t_restaurant_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.t_client(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

