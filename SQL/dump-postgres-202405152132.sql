--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.1

-- Started on 2024-05-15 21:32:44 PST

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
-- TOC entry 3430 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- TOC entry 3431 (class 0 OID 0)
-- Dependencies: 3430
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 5 (class 2615 OID 16480)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3432 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 16481)
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    payment_id integer NOT NULL,
    transaction_no character varying,
    amount bigint,
    dt_created timestamp without time zone DEFAULT now(),
    session_id integer,
    remarks text
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 16487)
-- Name: payments_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_payment_id_seq OWNER TO postgres;

--
-- TOC entry 3434 (class 0 OID 0)
-- Dependencies: 216
-- Name: payments_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_payment_id_seq OWNED BY public.payments.payment_id;


--
-- TOC entry 217 (class 1259 OID 16488)
-- Name: rates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rates (
    rate_id smallint NOT NULL,
    name character varying(50) NOT NULL,
    garage text NOT NULL,
    no_garage text NOT NULL,
    dt_created timestamp without time zone DEFAULT now(),
    dt_updated timestamp without time zone DEFAULT now(),
    deleted boolean DEFAULT false,
    extra_towel smallint DEFAULT 20,
    extra_pillow smallint DEFAULT 20,
    extra_blanket smallint DEFAULT 20,
    extra_single_bed smallint DEFAULT 200,
    extra_double_bed smallint DEFAULT 300,
    extra_person smallint DEFAULT 100
);


ALTER TABLE public.rates OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16496)
-- Name: rates_rate_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rates_rate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rates_rate_id_seq OWNER TO postgres;

--
-- TOC entry 3435 (class 0 OID 0)
-- Dependencies: 218
-- Name: rates_rate_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rates_rate_id_seq OWNED BY public.rates.rate_id;


--
-- TOC entry 219 (class 1259 OID 16497)
-- Name: rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rooms (
    room_no smallint NOT NULL,
    type character varying(50) NOT NULL,
    transaction_no character varying(50),
    status smallint
);


ALTER TABLE public.rooms OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16500)
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    session_id integer NOT NULL,
    user_id integer,
    login_dt timestamp with time zone DEFAULT now(),
    logout_dt timestamp with time zone
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16504)
-- Name: sessions_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sessions_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sessions_session_id_seq OWNER TO postgres;

--
-- TOC entry 3436 (class 0 OID 0)
-- Dependencies: 221
-- Name: sessions_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sessions_session_id_seq OWNED BY public.sessions.session_id;


--
-- TOC entry 222 (class 1259 OID 16505)
-- Name: transaction_ref_no_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transaction_ref_no_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transaction_ref_no_seq OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16506)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    transaction_no character varying(50) DEFAULT format('TRN%s'::text, lpad((nextval('public.transaction_ref_no_seq'::regclass))::text, 10, '0'::text)) NOT NULL,
    room_no smallint NOT NULL,
    dt_check_in timestamp with time zone DEFAULT now(),
    dt_check_out timestamp with time zone,
    bill bigint,
    duration smallint,
    base_time smallint,
    additional_time smallint,
    rate_id smallint,
    remarks text,
    extra_towel smallint DEFAULT 0,
    extra_pillow smallint DEFAULT 0,
    extra_blanket smallint DEFAULT 0,
    extra_single_bed smallint DEFAULT 0,
    extra_double_bed smallint DEFAULT 0,
    extra_person smallint DEFAULT 0
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 16513)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16514)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer DEFAULT nextval('public.users_id_seq'::regclass) NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    admin boolean DEFAULT false,
    dt_created timestamp without time zone DEFAULT now(),
    dt_updated timestamp without time zone DEFAULT now(),
    deleted boolean DEFAULT false
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 3227 (class 2604 OID 16522)
-- Name: payments payment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN payment_id SET DEFAULT nextval('public.payments_payment_id_seq'::regclass);


--
-- TOC entry 3229 (class 2604 OID 16523)
-- Name: rates rate_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rates ALTER COLUMN rate_id SET DEFAULT nextval('public.rates_rate_id_seq'::regclass);


--
-- TOC entry 3239 (class 2604 OID 16524)
-- Name: sessions session_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions ALTER COLUMN session_id SET DEFAULT nextval('public.sessions_session_id_seq'::regclass);


--
-- TOC entry 3414 (class 0 OID 16481)
-- Dependencies: 215
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3416 (class 0 OID 16488)
-- Dependencies: 217
-- Data for Name: rates; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rates VALUES (1, 'Default', '{"hourly":"100","three":"300","six":"500","twelve":"900","twenty_four":"1200"}', '{"hourly":"100","three":"250","six":"450","twelve":"700","twenty_four":"1000"}', '2023-04-10 19:08:41.292715', '2023-06-19 23:23:57.823366', false, 20, 20, 20, 200, 300, 100);
INSERT INTO public.rates VALUES (3, 'Senior Discount', '{"three":"240","six":"400","twelve":"640","twenty_four":"960","hourly":"80"}', '{"three":"200","six":"360","twelve":"560","twenty_four":"800","hourly":"80"}', '2023-04-12 18:46:07.957377', '2023-04-12 18:46:07.957377', false, 20, 20, 20, 200, 300, 100);
INSERT INTO public.rates VALUES (2, 'KCC Discount', '{"hourly":"90","three":"270","six":"450","twelve":"720","twenty_four":"1080"}', '{"hourly":"90","three":"180","six":"405","twelve":"540","twenty_four":"810"}', '2023-04-12 18:36:32.546515', '2023-07-24 23:17:51.218751', false, 20, 20, 20, 200, 300, 100);


--
-- TOC entry 3418 (class 0 OID 16497)
-- Dependencies: 219
-- Data for Name: rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rooms VALUES (1, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (2, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (3, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (4, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (5, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (6, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (7, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (8, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (9, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (10, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (11, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (12, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (13, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (14, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (15, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (16, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (17, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (18, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (19, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (20, 'garage', NULL, 1);
INSERT INTO public.rooms VALUES (21, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (22, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (23, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (24, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (25, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (26, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (27, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (28, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (29, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (30, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (31, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (32, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (33, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (34, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (35, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (36, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (37, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (38, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (39, 'no_garage', NULL, 1);
INSERT INTO public.rooms VALUES (40, 'no_garage', NULL, 1);


--
-- TOC entry 3419 (class 0 OID 16500)
-- Dependencies: 220
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3422 (class 0 OID 16506)
-- Dependencies: 223
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 3424 (class 0 OID 16514)
-- Dependencies: 225
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (1, 'admin', 'admin', 'admin', '1234', true, '2024-03-09 06:42:33.208784', '2024-03-09 06:42:33.208784', false);


--
-- TOC entry 3437 (class 0 OID 0)
-- Dependencies: 216
-- Name: payments_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_payment_id_seq', 1, false);


--
-- TOC entry 3438 (class 0 OID 0)
-- Dependencies: 218
-- Name: rates_rate_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rates_rate_id_seq', 4, false);


--
-- TOC entry 3439 (class 0 OID 0)
-- Dependencies: 221
-- Name: sessions_session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sessions_session_id_seq', 1, false);


--
-- TOC entry 3440 (class 0 OID 0)
-- Dependencies: 222
-- Name: transaction_ref_no_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transaction_ref_no_seq', 1, false);


--
-- TOC entry 3441 (class 0 OID 0)
-- Dependencies: 224
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, false);


--
-- TOC entry 3255 (class 2606 OID 16526)
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (payment_id);


--
-- TOC entry 3257 (class 2606 OID 16528)
-- Name: rates rates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rates
    ADD CONSTRAINT rates_pkey PRIMARY KEY (rate_id);


--
-- TOC entry 3259 (class 2606 OID 16530)
-- Name: rooms rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (room_no);


--
-- TOC entry 3261 (class 2606 OID 16532)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (session_id);


--
-- TOC entry 3263 (class 2606 OID 16534)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_no);


--
-- TOC entry 3265 (class 2606 OID 16536)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 3267 (class 2606 OID 16538)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 3268 (class 2606 OID 16539)
-- Name: payments payments_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(session_id);


--
-- TOC entry 3269 (class 2606 OID 16544)
-- Name: payments payments_transaction_no_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_transaction_no_fkey FOREIGN KEY (transaction_no) REFERENCES public.transactions(transaction_no);


--
-- TOC entry 3270 (class 2606 OID 16549)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- TOC entry 3433 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2024-05-15 21:32:44 PST

--
-- PostgreSQL database dump complete
--

