package util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class ImageUtilTest {

    @Test
    void testSlugify() {
        assertEquals("dellcomputer", ImageUtil.slugify("Dell Computer"));
        assertEquals("samsungmonitor123", ImageUtil.slugify("Samsung-Monitor 123!"));
        assertEquals("tastierameccanica", ImageUtil.slugify("Tastiera Meccanica"));
        assertEquals("aaaaa", ImageUtil.slugify("àáäâa"));
        assertEquals("eeeee", ImageUtil.slugify("èéëêe"));
        assertEquals("iiiii", ImageUtil.slugify("ìíïîi"));
        assertEquals("ooooo", ImageUtil.slugify("òóöôo"));
        assertEquals("uuuuu", ImageUtil.slugify("ùúüûu"));
        assertEquals("", ImageUtil.slugify(null));
        assertEquals("", ImageUtil.slugify(""));
        assertEquals("", ImageUtil.slugify("    "));
    }
}
