PGDMP  :    9                }            real_estate_agency    17.4    17.4 #    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16388    real_estate_agency    DATABASE     x   CREATE DATABASE real_estate_agency WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'ru-RU';
 "   DROP DATABASE real_estate_agency;
                     postgres    false            �            1259    16408    agent    TABLE     �   CREATE TABLE public.agent (
    agent_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    phone character varying(255),
    email character varying(255)
);
    DROP TABLE public.agent;
       public         heap r       postgres    false            �            1259    16407    agent_agent_id_seq    SEQUENCE     �   CREATE SEQUENCE public.agent_agent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.agent_agent_id_seq;
       public               postgres    false    222            �           0    0    agent_agent_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.agent_agent_id_seq OWNED BY public.agent.agent_id;
          public               postgres    false    221            �            1259    16399    client    TABLE     �   CREATE TABLE public.client (
    client_id integer NOT NULL,
    first_name character varying(255),
    last_name character varying(255),
    phone character varying(255),
    email character varying(255)
);
    DROP TABLE public.client;
       public         heap r       postgres    false            �            1259    16398    client_client_id_seq    SEQUENCE     �   CREATE SEQUENCE public.client_client_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.client_client_id_seq;
       public               postgres    false    220            �           0    0    client_client_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.client_client_id_seq OWNED BY public.client.client_id;
          public               postgres    false    219            �            1259    16390    property    TABLE     ~  CREATE TABLE public.property (
    property_id integer NOT NULL,
    type character varying(255),
    address character varying(255),
    price numeric(15,2),
    bedrooms integer,
    bathrooms integer,
    area numeric(10,2),
    description text,
    photo_url character varying(255),
    status character varying(255),
    latitude numeric(10,7),
    longitude numeric(10,7)
);
    DROP TABLE public.property;
       public         heap r       postgres    false            �            1259    16389    property_property_id_seq    SEQUENCE     �   CREATE SEQUENCE public.property_property_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.property_property_id_seq;
       public               postgres    false    218            �           0    0    property_property_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.property_property_id_seq OWNED BY public.property.property_id;
          public               postgres    false    217            �            1259    16429    transaction    TABLE     �   CREATE TABLE public.transaction (
    transaction_id integer NOT NULL,
    property_id integer,
    client_id integer,
    agent_id integer,
    date date,
    price numeric(15,2)
);
    DROP TABLE public.transaction;
       public         heap r       postgres    false            �            1259    16428    transaction_transaction_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transaction_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.transaction_transaction_id_seq;
       public               postgres    false    224            �           0    0    transaction_transaction_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.transaction_transaction_id_seq OWNED BY public.transaction.transaction_id;
          public               postgres    false    223            2           2604    16411    agent agent_id    DEFAULT     p   ALTER TABLE ONLY public.agent ALTER COLUMN agent_id SET DEFAULT nextval('public.agent_agent_id_seq'::regclass);
 =   ALTER TABLE public.agent ALTER COLUMN agent_id DROP DEFAULT;
       public               postgres    false    221    222    222            1           2604    16402    client client_id    DEFAULT     t   ALTER TABLE ONLY public.client ALTER COLUMN client_id SET DEFAULT nextval('public.client_client_id_seq'::regclass);
 ?   ALTER TABLE public.client ALTER COLUMN client_id DROP DEFAULT;
       public               postgres    false    220    219    220            0           2604    16393    property property_id    DEFAULT     |   ALTER TABLE ONLY public.property ALTER COLUMN property_id SET DEFAULT nextval('public.property_property_id_seq'::regclass);
 C   ALTER TABLE public.property ALTER COLUMN property_id DROP DEFAULT;
       public               postgres    false    217    218    218            3           2604    16432    transaction transaction_id    DEFAULT     �   ALTER TABLE ONLY public.transaction ALTER COLUMN transaction_id SET DEFAULT nextval('public.transaction_transaction_id_seq'::regclass);
 I   ALTER TABLE public.transaction ALTER COLUMN transaction_id DROP DEFAULT;
       public               postgres    false    223    224    224            �          0    16408    agent 
   TABLE DATA           N   COPY public.agent (agent_id, first_name, last_name, phone, email) FROM stdin;
    public               postgres    false    222   �)       �          0    16399    client 
   TABLE DATA           P   COPY public.client (client_id, first_name, last_name, phone, email) FROM stdin;
    public               postgres    false    220   �*       �          0    16390    property 
   TABLE DATA           �   COPY public.property (property_id, type, address, price, bedrooms, bathrooms, area, description, photo_url, status, latitude, longitude) FROM stdin;
    public               postgres    false    218   �+       �          0    16429    transaction 
   TABLE DATA           d   COPY public.transaction (transaction_id, property_id, client_id, agent_id, date, price) FROM stdin;
    public               postgres    false    224   H/       �           0    0    agent_agent_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.agent_agent_id_seq', 4, true);
          public               postgres    false    221            �           0    0    client_client_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.client_client_id_seq', 13, true);
          public               postgres    false    219            �           0    0    property_property_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.property_property_id_seq', 13, true);
          public               postgres    false    217            �           0    0    transaction_transaction_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.transaction_transaction_id_seq', 13, true);
          public               postgres    false    223            9           2606    16415    agent agent_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.agent
    ADD CONSTRAINT agent_pkey PRIMARY KEY (agent_id);
 :   ALTER TABLE ONLY public.agent DROP CONSTRAINT agent_pkey;
       public                 postgres    false    222            7           2606    16406    client client_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.client
    ADD CONSTRAINT client_pkey PRIMARY KEY (client_id);
 <   ALTER TABLE ONLY public.client DROP CONSTRAINT client_pkey;
       public                 postgres    false    220            5           2606    16397    property property_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.property
    ADD CONSTRAINT property_pkey PRIMARY KEY (property_id);
 @   ALTER TABLE ONLY public.property DROP CONSTRAINT property_pkey;
       public                 postgres    false    218            ;           2606    16434    transaction transaction_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_pkey PRIMARY KEY (transaction_id);
 F   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_pkey;
       public                 postgres    false    224            <           2606    16445 "   transaction transaction_agent_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_agent_fkey FOREIGN KEY (agent_id) REFERENCES public.agent(agent_id);
 L   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_agent_fkey;
       public               postgres    false    222    224    4665            =           2606    16440 #   transaction transaction_client_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_client_fkey FOREIGN KEY (client_id) REFERENCES public.client(client_id);
 M   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_client_fkey;
       public               postgres    false    4663    220    224            >           2606    16435 %   transaction transaction_property_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.transaction
    ADD CONSTRAINT transaction_property_fkey FOREIGN KEY (property_id) REFERENCES public.property(property_id);
 O   ALTER TABLE ONLY public.transaction DROP CONSTRAINT transaction_property_fkey;
       public               postgres    false    4661    218    224            �   �   x�e��
�0Dϛɢ�!�&To�/!]���д�����q��#\�k�#�!سz���.3%����0O�qp~W�T'�h �f�['h<���g��s��@V�Y��j�[s*�n�m����
����uGc���B�      �   R  x�M�QK�0ǟ��.ͺnݛ��:��
��r��6����&i;r���]��Qi���j�(�"圧 X���hIi֘6Y`kj��z�!��t����i���V��J`k�eT�Z�@3"V{IK�huV���<.����%�H*p7H�pO�q�$]������{��քWs���#��X�e�q5qfg�k<)j�';�n2�,�=���vB�T��|KW`���_�:�;����#q�gC������$��s�D�P�	{c��]'�WљX���;j�|A�>��P�i<d��������K�Q�~N�8���R�ၬU��C�9�'L9�,I�G��}      �   H  x�u�Mr�8���)p ��_�Nv���N<����j6�1	Z�r��#�hQR$���n~�����e'{ׂq������~�o�s�/o��ҬA�@��_�x�����c��r_�n�k��@��`K�?no�l;qe�[ٹ4��[��ӕ�@�4f�bu��2Nr^�E��G;@xFU]����ְ�#��B�w����@���_�p�Fc�Y�V�AY3�u��K`�Xv	��h)m�r�$MM8���a�X�yԍ������q1����/^z�)���5���]���/?��,a3^�C��8�6AM�`���aK����,f&�'�}#��7젨2�C`��j�gl�\�Y�S��Ņȋ W`���o���>�o�����J6s�e>�jXK�qvk�N��s�/"��s���T/�o_� ��Ԗp�-v�(qP�;��᳭�7��i��*�v���%�p������$�0�ɇ{�/�E�TO��������C��g{U�g@��e�W������K�@�b.�	��'�ލ�����ea(��v�D�[օ�
gF�@cZ <�vUN�/��t��E �|>�j���fF�d��;���Z�0���9��4rq�{�<&9��⌵�����~����?BD�S����(�5pV暰�o�+�2/C�D�dIO���LS����@�I������Uj4��̹�Ӊ%�b��!�B�Or\�ר�{Y����o��I"N`Z��U�M�6D Z�}v�N�|�a��>|���m=d�Yb~X��~�+|s*1��KWn���\�WĤ���:(���^�����(��]�B7      �   �   x�M��!�c.n�������
�U�Z�ȋR[��!���Ȣ"T�	#lp~��9K�༡U�o����p4B��c2�N�͗�w�Iת�{��N��6B�����&`�I׍�b`���7UE<wY'�]��춲�u�+�����\��/�?�     