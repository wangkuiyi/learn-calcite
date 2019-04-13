import javafx.util.Pair;
import org.apache.calcite.sql.SqlNode;
import org.apache.calcite.sql.parser.SqlParseException;
import org.apache.calcite.sql.parser.SqlParser;
import org.apache.calcite.sql.parser.SqlParserPos;

public class HelloCalcite {

  private static int PosToIndex(String query, SqlParserPos pos) {
    int line = 0, column = 0;

    for (int i = 0; i < query.length(); i++) {
      if (line == pos.getLineNum() - 1 && column == pos.getColumnNum() - 1) {
        return i;
      }

      if (query.charAt(i) == '\n') {
        line++;
        column = 0;
      } else {
        column++;
      }
    }

    return query.length();
  }

  private static Pair<Integer, SqlParseException> parse(String query) {
    try {
      SqlParser parser = SqlParser.create(query);
      SqlNode sqlNode = parser.parseQuery();

    } catch (SqlParseException e) {
      int epos = PosToIndex(query, e.getPos());
      try {
        SqlParser parser = SqlParser.create(query.substring(0, epos));
        SqlNode sqlNode = parser.parseQuery();
      } catch (SqlParseException ee) {
        return new Pair<Integer, SqlParseException>(epos, ee);
      }
      return new Pair<Integer, SqlParseException>(epos, null);
    }

    return new Pair<Integer, SqlParseException>(query.length(), null);
  }

  public static void main(String[] args) {
    String query =
        "Select a,b,c from d where\n d.id in (select id from (select id from e)) TRAIN DNNClassifier";
    System.out.println(parse(query));
  }
}
