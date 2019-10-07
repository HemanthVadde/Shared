CREATE TYPE CRUDQ_Type AS ENUM('CREATE','ALTER','INSERT', 'UPDATE','UPSERT', 'DELETE','DROP','QUERY');


CREATE TABLE Posts
(
  PostId SERIAL,
  PostContent TEXT,
  PostTitle VARCHAR(255),
  PostAuthor VARCHAR(255)
);


CREATE OR REPLACE FUNCTION FN_CRUDQ_POSTS
(
  data_object jsonb,
  operationtype CRUDQ_Type,
  _Postid OUT INT,
  _PostContent OUT TEXT,
  _PostTitle OUT VARCHAR(255),
  _PostAuthor OUT VARCHAR(255)
) RETURNS SETOF RECORD AS
$$
DECLARE
  r RECORD;
  _Query TEXT;
  _QueryCount INT DEFAULT jsonb_array_length(data_object);
BEGIN

  IF _QueryCount = 0
  THEN
    RAISE EXCEPTION 'Queries are not being sent. Please verify';

  ELSE
    RAISE WARNING 'Got Query COunt as %',_QueryCount;

    For r in (SELECT jsonb_array_elements_text(data_object))
    LOOP


      EXECUTE (r.jsonb_array_elements_text)::text;
      RAISE WARNING 'Got Query as %',(r.jsonb_array_elements_text)::text;
      RETURN QUERY
      INSERT INTO Posts
      (
        PostContent,
        PostTitle,
        PostAuthor
      )
      SELECT
        (r.jsonb_array_elements_text)::text,
        operationtype,
        current_user
      RETURNING
        PostId,
        PostContent,
        PostTitle,
        PostAuthor;
    END LOOP;
  END IF;

END;
$$ LANGUAGE PLPGSQL;


CREATE OR REPLACE FUNCTION FN_GET_COUNTS
(
  data_object jsonb,
  _result OUT jsonb) RETURNS JSONB AS
$$
BEGIN

  SELECT to_jsonb(array_agg(q)) INTO _result
  FROM
  (
    SELECT
      R As SearchString,
      SUM(Occ) As Frequency,
      SUM(CASE WHEN OCC = 0 THEN 0 ELSE 1 END) AS COUNT
    FROM (SELECT R,
      (length(PostContent)-length(replace(PostContent,R,'')))/length(R) as Occ
    FROM jsonb_array_elements_text(data_object) AS R
    CROSS JOIN POSTS P) A
    GROUP BY R) q;

END;
$$ LANGUAGE PLPGSQL;



